//
//  ThirdTabCoordinator.swift
//  MovieCatalog
//
//  Created by dark type on 13.10.2024.
//

import SwiftUI

class FavoritesTabCoordinator: Coordinator {
    var navigationController = UINavigationController()
    var childCoordinators = [Coordinator]()
    private var viewModel = FavoriteFilmsViewModel()

    init() {
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.isNavigationBarHidden = true
        viewModel.delegate = self
    }

    func start() {
        let favoritesView = FavoritesView(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: favoritesView)
        hostingController.view.backgroundColor = .clear
        hostingController.edgesForExtendedLayout = [.top, .bottom]
        hostingController.modalPresentationStyle = .fullScreen
        navigationController.setViewControllers([hostingController], animated: false)
    }

    func showMovieDetail(for movie: MoviesGeneral) {
        let movieDetail = Movie(
            id: movie.id,
            name: movie.name,
            poster: movie.poster,
            isFavorite: movie.isFavorite,
            genres: movie.genres
        )
        let detailView = MovieDetailView(movie: movieDetail)
        let hostingController = UIHostingController(rootView: detailView)
        navigationController.pushViewController(hostingController, animated: true)
    }
}

extension FavoritesTabCoordinator: FavoriteFilmsViewModelDelegate {
    func favoriteFilmsViewModelDidSelectMovie(_ movie: MoviesGeneral) {
        showMovieDetail(for: movie)
    }
}
