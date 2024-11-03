//
//  Coordinator.swift
//  MovieCatalog
//
//  Created by dark type on 11.10.2024.
//

import UIKit

protocol Coordinator {
    func start()
    var navigationController: UINavigationController { get }
    var childCoordinators: [Coordinator] { get set }
}
