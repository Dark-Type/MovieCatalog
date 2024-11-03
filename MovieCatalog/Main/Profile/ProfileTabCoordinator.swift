//
//  FourthTabCoordinator.swift
//  MovieCatalog
//
//  Created by dark type on 13.10.2024.
//

import UIKit

class ProfileTabCoordinator: Coordinator {
    var navigationController = UINavigationController()
    var childCoordinators = [Coordinator]()
    var logoutHandler: (() -> Void)?

    init() {
        navigationController.navigationBar.prefersLargeTitles = true
    }

    func start() {
        let viewModel = ProfileViewModel()
        let profileViewController = ProfileVC(viewModel: viewModel)
        profileViewController.logoutAction = { [weak self] in
            self?.logout()
        }
        viewModel.delegate = profileViewController
        viewModel.fetchUserProfile {}
        navigationController.setViewControllers([profileViewController], animated: false)
    }

    private func logout() {
        logoutHandler?()
    }
}
