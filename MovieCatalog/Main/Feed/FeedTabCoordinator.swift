//
//  SecondTabCoordinator.swift
//  MovieCatalog
//
//  Created by dark type on 11.10.2024.
//

import UIKit

class FeedTabCoordinator: Coordinator {
    var navigationController = UINavigationController()
    var childCoordinators = [Coordinator]()
    private var viewModel = FeedVM()
    
    lazy var feedViewController: FeedVC = {
        let vc = FeedVC(viewModel: viewModel)
        vc.title = "Feed"
        return vc
    }()
    
    func start() {
        navigationController.isNavigationBarHidden = true
        navigationController.setViewControllers([feedViewController], animated: false)
    }
}
