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
    weak var mainCoordinator: MainCoordinator?

    init(mainCoordinator: MainCoordinator) {
        self.mainCoordinator = mainCoordinator
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.isNavigationBarHidden = true
        viewModel.delegate = self
    }

    func start() {
        let favoritesView = FavoritesView(viewModel: viewModel, coordinator: self)
        let hostingController = UIHostingController(rootView: favoritesView)
        hostingController.view.backgroundColor = .clear
        hostingController.edgesForExtendedLayout = [.top, .bottom]
        hostingController.modalPresentationStyle = .fullScreen
        navigationController.setViewControllers([hostingController], animated: false)
    }

    func navigateToFeed() {
        mainCoordinator?.selectTab(index: 0) // Assuming the Feed tab is at index 0
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
