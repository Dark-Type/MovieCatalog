//
//  FIrstVM.swift
//  MovieCatalog
//
//  Created by dark type on 11.10.2024.
//

import UIKit

protocol MoviesViewModelDelegate: AnyObject {
    func moviesCoordinatorDidSelectMovie(_ movie: MoviesGeneral)
    func moviesCoordinatorDidSelectRandomMovie(_ movie: MoviesGeneral)
    func moviesCoordinatorDidSelectAllMovies()
}

class MoviesViewModel {
    weak var delegate: MoviesViewModelDelegate?
    var featuredMovies: [MoviesGeneral] = []
    var favoriteMovies: [MoviesGeneral] = []
    var allMovies: [MoviesGeneral] = []
    var currentPageIndex = 1
    var isLoading = false
    var hasMoreMovies = true

    var onMoviesViewModelDidUpdateMovies: (() -> Void)?
    var onMoviesViewModelDidUpdateFavoriteMovies: (() -> Void)?
    var onMoviesViewModelDidUpdateFeaturedMovies: (() -> Void)?

    func loadInitialData() {
        let group = DispatchGroup()

        group.enter()
        DataAdapterService.shared.fetchAndProcessInitialData { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.featuredMovies = data.featuredMovies
                self.allMovies = data.allMovies
                self.currentPageIndex += 2
                onMoviesViewModelDidUpdateFeaturedMovies?()
                onMoviesViewModelDidUpdateMovies?()
            case .failure(let error):
                print("Failed to fetch initial movies: \(error)")
            }
            group.leave()
        }

        group.enter()
        MovieService.shared.fetchFavoriteMovies { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let movies):
                DataAdapterService.shared.adaptMoviesSummaryData(movies, favoriteMovies: movies) {[weak self] adaptedResult in
                    switch adaptedResult {
                    case .success(let adaptedMovies):
                        self?.favoriteMovies = adaptedMovies
                        self?.onMoviesViewModelDidUpdateFavoriteMovies?()
                    case .failure(let error):
                        print("Failed to adapt favorite movies: \(error)")
                    }
                }
            case .failure(let error):
                print("Failed to fetch favorite movies: \(error)")
            }
            group.leave()
        }

        group.notify(queue: .main) {
            print("Initial data loading completed")
        }
    }

    func loadMovies() {
        guard !isLoading, hasMoreMovies else {
            print("Skipping loadMovies: isLoading=\(isLoading), hasMoreMovies=\(hasMoreMovies)")
            return
        }
        isLoading = true
        print("Fetching movies for page \(currentPageIndex)")
        MovieService.shared.fetchMovies(page: currentPageIndex) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            switch result {
            case .success(let movies):
                print("Fetched \(movies.count) movies for page \(self.currentPageIndex)")
                let filteredMovies = movies.filter { movie in
                    !self.featuredMovies.contains(where: { $0.id == movie.id })
                }
                self.allMovies.append(contentsOf: filteredMovies)
                print("Total movies count: \(self.allMovies.count)")
                self.currentPageIndex += 1
                self.hasMoreMovies = !filteredMovies.isEmpty
                onMoviesViewModelDidUpdateMovies?()
            case .failure(let error):
                print("Failed to fetch movies: \(error)")
            }
        }
    }

    func loadFavoriteMovies() {
        MovieService.shared.fetchFavoriteMovies { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let movies):
                DataAdapterService.shared.adaptMoviesSummaryData(movies, favoriteMovies: movies) { [weak self] adaptedResult in
                    switch adaptedResult {
                    case .success(let adaptedMovies):
                        self?.favoriteMovies = adaptedMovies
                        self?.onMoviesViewModelDidUpdateFavoriteMovies?()
                    case .failure(let error):
                        print("Failed to adapt favorite movies: \(error)")
                    }
                }
            case .failure(let error):
                print("Failed to fetch favorite movies: \(error)")
            }
        }
    }

    func loadFeaturedMovies() {
        MovieService.shared.fetchMovies(page: 1) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let movies):
                self.featuredMovies = Array(movies.shuffled().prefix(5))
                onMoviesViewModelDidUpdateFeaturedMovies?()
            case .failure(let error):
                print("Failed to fetch featured movies: \(error)")
            }
        }
    }

    func selectRandomMovie() {
        guard !allMovies.isEmpty else { return }
        let randomMovie = allMovies.randomElement()!
        delegate?.moviesCoordinatorDidSelectRandomMovie(randomMovie)
    }

    func selectMovie(at indexPath: IndexPath, in collectionView: UICollectionView) {
        if collectionView.tag == 0 {
            let movie = favoriteMovies[indexPath.item]
            delegate?.moviesCoordinatorDidSelectMovie(movie)
        } else {
            let movie = allMovies[indexPath.item]
            delegate?.moviesCoordinatorDidSelectMovie(movie)
        }
    }

    func selectAllMovies() {
        delegate?.moviesCoordinatorDidSelectAllMovies()
    }
}
