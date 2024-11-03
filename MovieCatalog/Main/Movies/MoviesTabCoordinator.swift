//
//  FirstTabCoordinator.swift
//  MovieCatalog
//
//  Created by dark type on 11.10.2024.
//

import SwiftUI
import UIKit

class MoviesTabCoordinator: Coordinator {
    var navigationController = UINavigationController()
    var childCoordinators = [Coordinator]()
    var favoritesCoordinator: FavoritesTabCoordinator?
    private var viewModel = MoviesViewModel()

    init() {
        navigationController.navigationBar.prefersLargeTitles = true
    }

    lazy var moviesViewController: MoviesVC = {
        let vc = MoviesVC(viewModel: viewModel)
        vc.title = "Фильмы"
        return vc
    }()
    func start() {
        navigationController.setViewControllers([moviesViewController], animated: false)
        viewModel.delegate = self
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
        navigationController.setNavigationBarHidden(true, animated: true)
        navigationController.pushViewController(hostingController, animated: true)
    }

    func showAllMovies() {
        favoritesCoordinator?.navigationController.popToRootViewController(animated: true)
        navigationController.tabBarController?.selectedIndex = 2
    }
}

extension MoviesTabCoordinator: MoviesViewModelDelegate {
    func moviesCoordinatorDidSelectMovie(_ movie: MoviesGeneral) {
        showMovieDetail(for: movie)
    }

    func moviesCoordinatorDidSelectRandomMovie(_ movie: MoviesGeneral) {
        showMovieDetail(for: movie)
    }

    func moviesCoordinatorDidSelectAllMovies() {
        showAllMovies()
    }
}
