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
    @Published var friends: [Author] = []
    @Published var favoriteGenres: [Genre] = []
    @Published var currentUserProfile: UserProfile?
    @Published var friendsWithHighReviewsCount: Int = 0
    @Published var isFavorite: Bool = false
    
    private let imageService = ImageService.shared
    private let dispatchGroup = DispatchGroup()
    
    init(movie: Movie) {
        self.movie = movie
        fetchUserProfile()
        checkFavoriteStatus()
    }

    private func fetchUserProfile() {
        ProfileService.shared.fetchUserProfile { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let userProfile):
                    self.currentUserProfile = userProfile
                    self.fetchAdditionalDetails()
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.fetchAdditionalDetails()
                }
            }
        }
    }
    
    func isFavoriteGenre(_ genre: Genre) -> Bool {
        return ServiceManager.shared.genresService.isFavorite(genre: genre)
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
        updatedMovie.budget = details.budget ?? 0
        updatedMovie.fees = details.fees ?? 0
        updatedMovie.ageLimit = "\(details.ageLimit)+"
        updatedMovie.tagline = details.tagline
        updatedMovie.description = details.description
        updatedMovie.country = details.country
        updatedMovie.year = details.year

        let totalMinutes = details.time
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60
        updatedMovie.time = hours > 0 ? "\(hours)h \(minutes)m" : "\(minutes)m"

        DispatchQueue.main.async {
            self.movie = updatedMovie
            print("Kreosoft details updated for movie: \(self.movie.name)")
            self.convertReviews(from: details.reviews)

            let averageRating = self.reviews.map { $0.rating }.average()
            if let average = averageRating {
                let averageReviewRating = Rating(
                    id: UUID().uuidString,
                    rating: average,
                    image: UIImage(named: "LogoImage") ?? UIImage()
                )
                self.movie.ratings.append(averageReviewRating)
                print(averageReviewRating)
                print(average)
                print(self.movie.ratings)
            }
        }
    }
    func addReview(rating: Int, comment: String, isAnonymous: Bool, completion: @escaping (Bool) -> Void) {
        isLoading = true
        
        let reviewRequest = AddReviewRequest(reviewText: comment, rating: rating, isAnonymous: isAnonymous)
        
        ReviewService.shared.addReview(movieId: movie.id, review: reviewRequest) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                switch result {
                case .success:
                    let newReview = Review(
                        id: UUID().uuidString,
                        reviewText: comment,
                        isAnonymous: isAnonymous,
                        createDateTime: self.getCurrentDateTimeString(),
                        author: self.currentUserAsAuthor(isAnonymous: isAnonymous),
                        rating: rating,
                        isUserReview: true
                    )
                    self.reviews.insert(newReview, at: 0)
                    completion(true)
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    completion(false)
                }
            }
        }
    }
       
    func editReview(review: Review, rating: Int, comment: String, isAnonymous: Bool, completion: @escaping (Bool) -> Void) {
        isLoading = true

        let reviewRequest = AddReviewRequest(reviewText: comment, rating: rating, isAnonymous: isAnonymous)

        ReviewService.shared.editReview(movieId: movie.id, reviewId: review.id, review: reviewRequest) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                switch result {
                case .success:
                    if let index = self.reviews.firstIndex(where: { $0.id == review.id }) {
                        self.reviews[index].rating = rating
                        self.reviews[index].reviewText = comment
                        self.reviews[index].isAnonymous = isAnonymous
                        self.reviews[index].author = self.currentUserAsAuthor(isAnonymous: isAnonymous)
                    }
                    completion(true)
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    completion(false)
                }
            }
        }
    }

    func loadFriendsWithHighReviews() {
        let friendDetails = FriendsService.shared.getFriends()

        for friend in friendDetails {
            print("Friend nickname: \(friend.nickName ?? "No nickname"), Friend name: \(friend.userId ?? "No name")")
        }

        for review in reviews {
            print("Author name: \(review.author.name) with rating: \(review.rating)")
        }

        let friendsWithHighReviews = friendDetails.filter { friend in
            reviews.contains { $0.author.name == friend.nickName && $0.rating > 5 }
        }

        friendsWithHighReviewsCount = friendsWithHighReviews.count
        friends = Array(friendsWithHighReviews.prefix(3)).map { Author(from: $0) }
        print("Loaded friends with high reviews: \(friends.map { $0.name })")
        loadAvatars()
    }

    private func loadAvatars() {
        for (index, friend) in friends.enumerated() {
            ImageService.shared.fetchImage(from: friend.avatarURL) { result in
                switch result {
                case .success(let image):
                    DispatchQueue.main.async {
                        self.friends[index].avatar = image
                        print("Loaded avatar for friend: \(friend.name)")
                    }
                case .failure:
                    DispatchQueue.main.async {
                        self.friends[index].avatar = UIImage(systemName: "person.crop.circle")
                        print("Set default avatar for friend: \(friend.name)")
                    }
                }
            }
        }
    }
       
    private func checkFavoriteStatus() {
        MovieService.shared.fetchFavoriteMovies { [weak self] result in
            switch result {
            case .success(let favoriteMovies):
                self?.isFavorite = favoriteMovies.contains { $0.id == self?.movie.id }
            case .failure(let error):
                self?.errorMessage = error.localizedDescription
            }
        }
    }

    func toggleFavoriteStatus() {
        if isFavorite {
            MovieService.shared.deleteFavoriteMovie(movieId: movie.id) { [weak self] result in
                switch result {
                case .success:
                    self?.isFavorite = false
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        } else {
            MovieService.shared.addFavoriteMovie(movieId: movie.id) { [weak self] result in
                switch result {
                case .success:
                    self?.isFavorite = true
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func deleteReview(review: Review, completion: @escaping (Bool) -> Void) {
        isLoading = true

        ReviewService.shared.deleteReview(movieId: movie.id, reviewId: review.id) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                switch result {
                case .success:
                    self.reviews.removeAll(where: { $0.id == review.id })
                    completion(true)
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    completion(false)
                }
            }
        }
    }
       
    private func getCurrentDateTimeString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter.string(from: Date())
    }

    func loadFavoriteGenres() {
        favoriteGenres = ServiceManager.shared.genresService.loadFavoriteGenres()
    }

    func toggleFavoriteGenre(_ genre: Genre) {
        ServiceManager.shared.genresService.toggleFavoriteStatus(for: genre)
        objectWillChange.send()
    }
       
    private func currentUserAsAuthor(isAnonymous: Bool) -> Author {
        if isAnonymous {
            return Author(id: "user", name: "Anonymous", avatarURL: "")
        } else if let userProfile = currentUserProfile {
            return Author(
                id: userProfile.id,
                name: userProfile.nickName,
                avatarURL: userProfile.avatarLink ?? ""
            )
        } else {
            return Author(id: "user", name: "Unknown User", avatarURL: "")
        }
    }
    
    private func convertReviews(from reviewDetailsArray: [ReviewDetails]) {
        let reviewGroup = DispatchGroup()
        var convertedReviews: [Review] = []

        for reviewDetails in reviewDetailsArray {
            reviewGroup.enter()
            Review.create(from: reviewDetails, imageService: imageService) { [weak self] review in
                guard let self = self else {
                    reviewGroup.leave()
                    return
                }
                var mutableReview = review
                if let currentUser = self.currentUserProfile {
                    mutableReview.isUserReview = mutableReview.author.name == currentUser.nickName
                } else {
                    mutableReview.isUserReview = false
                }
                convertedReviews.append(mutableReview)
                reviewGroup.leave()
            }
        }

        reviewGroup.notify(queue: .main) {
            self.reviews = convertedReviews.sorted { $0.isUserReview && !$1.isUserReview }
            self.movie.reviews = convertedReviews
            print("Reviews updated for movie: \(self.movie.name)")
            self.loadFriendsWithHighReviews()
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
        guard !isEmpty else { return nil }
        let sum = reduce(0, +)
        return Double(sum) / Double(count)
    }
}
