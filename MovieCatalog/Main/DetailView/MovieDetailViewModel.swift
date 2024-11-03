//
//  MovieDetailViewModel.swift
//  MovieCatalog
//
//  Created by dark type on 03.11.2024.
//

import Foundation
import UIKit

class MovieDetailViewModel: ObservableObject {
    @Published var movie: Movie
    @Published var isLoading: Bool = true
    @Published var errorMessage: String?
    @Published var reviews: [Review] = []
    
    private let imageService = ImageService.shared
    private let dispatchGroup = DispatchGroup()
    
    init(movie: Movie) {
        self.movie = movie
        fetchAdditionalDetails()
    }
    
    private func fetchAdditionalDetails() {
        isLoading = true
        
        dispatchGroup.enter()
        KinopoiskService.shared.searchFilmsByKeyword(keyword: movie.name) { [weak self] result in
            guard let self = self else {
                self?.dispatchGroup.leave()
                return
            }
            DispatchQueue.main.async {
                switch result {
                case .success(let films):
                    if let film = films.first(where: { $0.nameRu == self.movie.name || $0.nameEn == self.movie.name }) {
                        let filmId = film.filmId
                        self.movie.externalId = filmId
                        
                        self.fetchKinopoiskDetails(filmId: filmId)
                        self.fetchKreosoftDetails(movieId: "\(self.movie.id)")
                        self.fetchStaff(filmId: filmId)
                    } else {
                        self.errorMessage = "No matching film found."
                        print("No matching film found in Kinopoisk API.")
                    }
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    print("searchFilmsByKeyword Failure: \(error.localizedDescription)")
                }
                self.dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.checkIfLoadingComplete()
        }
    }
    
    private func fetchKinopoiskDetails(filmId: Int) {
        dispatchGroup.enter()
        KinopoiskService.shared.fetchMovieDetails(id: filmId) { [weak self] result in
            guard let self = self else {
                self?.dispatchGroup.leave()
                return
            }
            DispatchQueue.main.async {
                switch result {
                case .success(let details):
                    self.updateKinopoiskDetails(with: details)
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    print("fetchKinopoiskDetails Failure: \(error.localizedDescription)")
                }
                self.dispatchGroup.leave()
            }
        }
    }
    
    private func fetchKreosoftDetails(movieId: String) {
        dispatchGroup.enter()
        MovieService.shared.fetchMovieDetails(movieId: movieId) { [weak self] result in
            guard let self = self else {
                self?.dispatchGroup.leave()
                return
            }
            DispatchQueue.main.async {
                switch result {
                case .success(let kreosoftDetails):
                    self.updateKreosoftDetails(with: kreosoftDetails)
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    print("fetchKreosoftDetails Failure: \(error.localizedDescription)")
                }
                self.dispatchGroup.leave()
            }
        }
    }
    
    private func fetchStaff(filmId: Int) {
        dispatchGroup.enter()
        KinopoiskService.shared.fetchStaff(filmId: filmId) { [weak self] result in
            guard let self = self else {
                self?.dispatchGroup.leave()
                return
            }
            DispatchQueue.main.async {
                switch result {
                case .success(let staffMembers):
                    KinopoiskService.shared.processStaff(staffMembers: staffMembers) { processResult in
                        DispatchQueue.main.async {
                            switch processResult {
                            case .success(let authors):
                                self.movie.directors = authors
                                print("Directors updated for movie: \(self.movie.name)")
                            case .failure(let error):
                                self.errorMessage = error.localizedDescription
                                print("processStaff Failure: \(error.localizedDescription)")
                            }
                            self.dispatchGroup.leave()
                        }
                    }
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    print("fetchStaff Failure: \(error.localizedDescription)")
                    self.dispatchGroup.leave()
                }
            }
        }
    }
    
    private func updateKinopoiskDetails(with details: MovieDetailsResponse) {
        let updatedMovie = movie
        
        if let ratingKinopoisk = details.ratingKinopoisk {
            let kinopoiskRating = Rating(
                id: UUID().uuidString,
                rating: ratingKinopoisk,
                image: UIImage(named: "kinopoisk") ?? UIImage()
            )
            updatedMovie.ratings.append(kinopoiskRating)
        }
        
        if let ratingImdb = details.ratingImdb {
            let imdbRating = Rating(
                id: UUID().uuidString,
                rating: ratingImdb,
                image: UIImage(named: "imdb") ?? UIImage()
            )
            updatedMovie.ratings.append(imdbRating)
        }
        
        DispatchQueue.main.async {
            self.movie = updatedMovie
            print("Kinopoisk details updated for movie: \(self.movie.name)")
        }
    }
    
    private func updateKreosoftDetails(with details: MovieDetailsData) {
        let updatedMovie = movie
        updatedMovie.budget = details.budget
        updatedMovie.fees = details.fees
        updatedMovie.ageLimit = "\(details.ageLimit)+"
        updatedMovie.tagline = details.tagline
        updatedMovie.description = details.description
        updatedMovie.country = details.country
        updatedMovie.year = details.year
        
        let totalMinutes = details.time
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60
        updatedMovie.time = hours > 0 ? "\(hours)h \(minutes)m" : "\(minutes)m"
        
        let averageRating = reviews.map { $0.rating }.average()
        if let average = averageRating {
            let averageReviewRating = Rating(
                id: UUID().uuidString,
                rating: average,
                image: UIImage(named: "LogoImage") ?? UIImage()
            )
            updatedMovie.ratings.append(averageReviewRating)
        }
        
        DispatchQueue.main.async {
            self.movie = updatedMovie
            print("Kreosoft details updated for movie: \(self.movie.name)")
            self.convertReviews(from: details.reviews)
        }
    }
    
    private func convertReviews(from reviewDetailsArray: [ReviewDetails]) {
        let reviewGroup = DispatchGroup()
        var convertedReviews: [Review] = []
            
        for reviewDetails in reviewDetailsArray {
            reviewGroup.enter()
            Review.create(from: reviewDetails, imageService: imageService) { review in
                convertedReviews.append(review)
                reviewGroup.leave()
            }
        }
            
        reviewGroup.notify(queue: .main) {
            self.reviews = convertedReviews
            self.movie.reviews = convertedReviews
            print("Reviews updated for movie: \(self.movie.name)")
        }
    }
    
    private func checkIfLoadingComplete() {
        DispatchQueue.main.async {
            self.isLoading = false
        }
    }
}

// MARK: - Array Extension

extension Array where Element == Int {
    func average() -> Double? {
        guard !self.isEmpty else { return nil }
        let sum = self.reduce(0, +)
        return Double(sum) / Double(self.count)
    }
}
