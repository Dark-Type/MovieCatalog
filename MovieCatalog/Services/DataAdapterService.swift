//
//  DataAdapterService.swift
//  MovieCatalog
//
//  Created by dark type on 01.11.2024.
//

import UIKit

class DataAdapterService {
    static let shared = DataAdapterService()
    private init() {}

    func adaptFilmData(_ filmData: Film) -> FilmProcessed {
        let posterImage: UIImage?
        if let url = URL(string: filmData.posterUrl), let data = try? Data(contentsOf: url) {
            posterImage = UIImage(data: data)
        } else {
            posterImage = UIImage(systemName: "photo")
        }

        return FilmProcessed(
            id: filmData.filmId,
            nameRu: filmData.nameRu,
            nameEn: filmData.nameEn,
            type: filmData.type,
            year: filmData.year,
            description: filmData.description,
            filmLength: filmData.filmLength,
            countries: filmData.countries,
            genres: filmData.genres,
            rating: filmData.rating,
            ratingVoteCount: filmData.ratingVoteCount,
            posterImage: posterImage
        )
    }

    func fetchAndProcessInitialData(completion: @escaping (Result<(featuredMovies: [MoviesGeneral], allMovies: [MoviesGeneral]), Error>) -> Void) {
        var allFetchedMovies: [MoviesGeneral] = []
        let group = DispatchGroup()

        for page in 1 ... 3 {
            group.enter()
            MovieService.shared.fetchMovies(page: page) { result in
                switch result {
                case .success(let movies):
                    allFetchedMovies.append(contentsOf: movies)
                case .failure(let error):
                    print("Failed to fetch movies for page \(page): \(error)")
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            if allFetchedMovies.isEmpty {
                completion(.failure(NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch movies"])))
            } else {
                let shuffledMovies = allFetchedMovies.shuffled()
                let featuredMovies = Array(shuffledMovies.prefix(5))
                let allMovies = Array(shuffledMovies.dropFirst(5))
                completion(.success((featuredMovies, allMovies)))
            }
        }
    }

   

    func adaptMovieSummaryData(_ movieData: MovieSummary, favoriteMovies: [MovieSummary], completion: @escaping (Result<MoviesGeneral, Error>) -> Void) {
        guard let imageURL = URL(string: movieData.poster), imageURL.scheme != nil else {
            completion(.failure(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        ImageService.shared.fetchImage(from: movieData.poster) { result in
            switch result {
            case .success(let image):
                let isFavorite = favoriteMovies.contains { $0.id == movieData.id }
                let averageRating = round((movieData.reviews.map { $0.rating }.reduce(0.0, +) / Double(max(movieData.reviews.count, 1))) * 10) / 10
                let genres = movieData.genres.map { genreSummary in
                    Genre(
                        id: genreSummary.id,
                        name: genreSummary.name,
                        isFavorite: GenreManager.shared.isFavorite(genre: Genre(id: genreSummary.id, name: genreSummary.name, isFavorite: false))
                    )
                }
                let movieGeneral = MoviesGeneral(
                    id: movieData.id,
                    name: movieData.name,
                    poster: image,
                    genres: genres,
                    rating: Double(averageRating),
                    isFavorite: isFavorite
                )
                completion(.success(movieGeneral))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func adaptMoviesSummaryData(_ moviesData: [MovieSummary], favoriteMovies: [MovieSummary], completion: @escaping (Result<[MoviesGeneral], Error>) -> Void) {
        var moviesGeneral: [MoviesGeneral] = []
        let group = DispatchGroup()

        for movieData in moviesData {
            group.enter()
            adaptMovieSummaryData(movieData, favoriteMovies: favoriteMovies) { result in
                switch result {
                case .success(let movieGeneral):
                    moviesGeneral.append(movieGeneral)
                case .failure(let error):
                    completion(.failure(error))
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            completion(.success(moviesGeneral))
        }
    }

    func adaptMovieSummaryToFeedMovie(_ movieData: MovieSummary, completion: @escaping (Result<FeedMovie, Error>) -> Void) {
        guard let imageURL = URL(string: movieData.poster), imageURL.scheme != nil else {
            completion(.failure(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        ImageService.shared.fetchImage(from: movieData.poster) { result in
            switch result {
            case .success(let image):
                let genres = movieData.genres.map { genreSummary in
                    Genre(
                        id: genreSummary.id,
                        name: genreSummary.name,
                        isFavorite: GenreManager.shared.isFavorite(genre: Genre(id: genreSummary.id, name: genreSummary.name, isFavorite: false))
                    )
                }
                let feedMovie = FeedMovie(
                    id: movieData.id,
                    name: movieData.name,
                    poster: image,
                    country: movieData.country,
                    year: movieData.year,
                    genres: genres
                )
                completion(.success(feedMovie))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    func adaptMoviesSummaryToFeedMovies(_ moviesData: [MovieSummary], completion: @escaping (Result<[FeedMovie], Error>) -> Void) {
        var feedMovies: [FeedMovie] = []
        let group = DispatchGroup()
        let semaphore = DispatchSemaphore(value: 1)

        for movieData in moviesData {
            group.enter()
            adaptMovieSummaryToFeedMovie(movieData) { result in
                switch result {
                case .success(let feedMovie):
                    semaphore.wait()
                    feedMovies.append(feedMovie)
                    semaphore.signal()
                case .failure(let error):
                    print("Failed to adapt movie with id \(movieData.id): \(error)")
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            completion(.success(feedMovies))
        }
    }
}
