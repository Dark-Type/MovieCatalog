//
//  MovieService.swift
//  MovieCatalog
//
//  Created by dark type on 01.11.2024.
//

import Alamofire
import UIKit

class MovieService {
    static let shared = MovieService()
    private init() {}

    private let baseURL = "https://react-midterm.kreosoft.space/api"

    func fetchMovies(page: Int, completion: @escaping (Result<[MoviesGeneral], Error>) -> Void) {
        let url = "\(baseURL)/movies/\(page)"
        print("Requesting URL: \(url)")

        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Token not found"])))
            return
        }

        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]

        AF.request(url, headers: headers).responseDecodable(of: MoviesResponse.self) { response in
            switch response.result {
            case .success(let moviesResponse):
                self.fetchFavoriteMovies { favoriteResult in
                    switch favoriteResult {
                    case .success(let favoriteMovies):
                        let visibleMovies = moviesResponse.movies.filter { !HiddenFilmsService.shared.isFilmHidden(withId: $0.id) }
                        DataAdapterService.shared.adaptMoviesSummaryData(visibleMovies, favoriteMovies: favoriteMovies, completion: completion)
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchFeedMovies(page: Int, completion: @escaping (Result<[FeedMovie], Error>) -> Void) {
        let url = "\(baseURL)/movies/\(page)"
        print("Requesting URL: \(url)")

        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Token not found"])))
            return
        }

        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]

        AF.request(url, headers: headers).responseDecodable(of: MoviesResponse.self) { response in
            switch response.result {
            case .success(let moviesResponse):
                let visibleMovies = moviesResponse.movies.filter { !HiddenFilmsService.shared.isFilmHidden(withId: $0.id) }
                DataAdapterService.shared.adaptMoviesSummaryToFeedMovies(visibleMovies, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchFavoriteMovies(completion: @escaping (Result<[MovieSummary], Error>) -> Void) {
        let url = "\(baseURL)/favorites"

        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Token not found"])))
            return
        }

        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]

        AF.request(url, method: .get, headers: headers).responseDecodable(of: FavoriteMoviesResponse.self) { response in
            switch response.result {
            case .success(let favoriteMoviesResponse):
                completion(.success(favoriteMoviesResponse.movies))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func deleteFavoriteMovie(movieId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let url = "\(baseURL)/favorites/\(movieId)/delete"

        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Token not found"])))
            return
        }

        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]

        AF.request(url, method: .post, headers: headers).response { response in
            switch response.result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func addFavoriteMovie(movieId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let url = "\(baseURL)/favorites/\(movieId)/add"

        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Token not found"])))
            return
        }

        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]

        AF.request(url, method: .post, headers: headers).response { response in
            switch response.result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchMovieDetails(movieId: String, completion: @escaping (Result<MovieDetailsData, Error>) -> Void) {
        let urlString = "\(baseURL)/movies/details/\(movieId)"
        print("Fetching movie details from URL: \(urlString)")

        AF.request(urlString)
            .validate()
            .responseDecodable(of: MovieDetailsData.self) { response in
                switch response.result {
                case .success(let movieDetails):
                    completion(.success(movieDetails))
                case .failure(let error):
                    if let data = response.data, let jsonString = String(data: data, encoding: .utf8) {
                    }
                    print("fetchMovieDetails Failure: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
    }
}
