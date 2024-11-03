//
//  FavoritesViewModel.swift
//  MovieCatalog
//
//  Created by dark type on 03.11.2024.
//

import SwiftUI

protocol FavoriteFilmsViewModelDelegate: AnyObject {
    func favoriteFilmsViewModelDidSelectMovie(_ movie: MoviesGeneral)
}

class FavoriteFilmsViewModel: ObservableObject {
    @Published var favoriteGenres: [Genre] = []
    @Published var favoriteFilms: [MoviesGeneral] = []
    weak var delegate: FavoriteFilmsViewModelDelegate?

    init() {
        loadFavoriteGenres()
        loadFavoriteFilms()
    }

    func loadFavoriteGenres() {
        favoriteGenres = GenreManager.shared.favoriteGenres
    }

    func loadFavoriteFilms() {
        MovieService.shared.fetchFavoriteMovies { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let movies):
                DataAdapterService.shared.adaptMoviesSummaryData(movies, favoriteMovies: movies) { [weak self] adaptedResult in
                    switch adaptedResult {
                    case .success(let adaptedMovies):
                        self?.favoriteFilms = adaptedMovies
                    case .failure(let error):
                        print("Failed to adapt favorite movies: \(error)")
                    }
                }
            case .failure(let error):
                print("Failed to fetch favorite movies: \(error)")
            }
        }
    }

    func selectMovie(_ movie: MoviesGeneral) {
        delegate?.favoriteFilmsViewModelDidSelectMovie(movie)
    }
}
