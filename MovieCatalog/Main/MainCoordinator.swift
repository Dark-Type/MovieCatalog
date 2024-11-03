//
//  MainCoordinator.swift
//  MovieCatalog
//
//  Created by dark type on 11.10.2024.
//
import UIKit

enum MainCoordinatorConstants {
    static let feedTitle = "Лента"
    static let feedImageName = "Feed"
    static let feedSelectedImageName = "FeedSelected"
    
    static let moviesTitle = "Фильмы"
    static let moviesImageName = "Movie"
    static let moviesSelectedImageName = "MovieSelected"
    
    static let favoritesTitle = "Избранное"
    static let favoritesImageName = "FavoritesBottomBar"
    static let favoritesSelectedImageName = "FavoritesBottomBarSelected"
    
    static let profileTitle = "Профиль"
    static let profileImageName = "Profile"
    static let profileSelectedImageName = "ProfileSelected"
    
    static let transitionDuration: TimeInterval = 0.5
    static let gradientImageSize = CGSize(width: 1, height: 1)
}


class MainCoordinator: NSObject, Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var logoutHandler: (() -> Void)?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let tabBarController = MCTabBarController()
        tabBarController.view.backgroundColor = ColorsEnum.baseDarkGrey
        animateTransition(to: tabBarController)

        let feedCoordinator = FeedTabCoordinator()
        feedCoordinator.start()
        childCoordinators.append(feedCoordinator)
        let feedVC = feedCoordinator.navigationController
        feedVC.hidesBottomBarWhenPushed = false
        setup(vc: feedVC, title: MainCoordinatorConstants.feedTitle, imageName: MainCoordinatorConstants.feedImageName, selectedImageName: MainCoordinatorConstants.feedSelectedImageName)

        let moviesCoordinator = MoviesTabCoordinator()
        moviesCoordinator.start()
        childCoordinators.append(moviesCoordinator)
        let moviesVC = moviesCoordinator.navigationController
        moviesVC.hidesBottomBarWhenPushed = false
        setup(vc: moviesVC, title: MainCoordinatorConstants.moviesTitle, imageName: MainCoordinatorConstants.moviesImageName, selectedImageName: MainCoordinatorConstants.moviesSelectedImageName)

        let favoritesCoordinator = FavoritesTabCoordinator()
        favoritesCoordinator.start()
        childCoordinators.append(favoritesCoordinator)
        let favoritesVC = favoritesCoordinator.navigationController
        favoritesVC.hidesBottomBarWhenPushed = false
        setup(vc: favoritesVC, title: MainCoordinatorConstants.favoritesTitle, imageName: MainCoordinatorConstants.favoritesImageName, selectedImageName: MainCoordinatorConstants.favoritesSelectedImageName)
        moviesCoordinator.favoritesCoordinator = favoritesCoordinator

        let profileCoordinator = ProfileTabCoordinator()
        profileCoordinator.start()
        profileCoordinator.logoutHandler = { [weak self] in
            self?.logout()
        }
        childCoordinators.append(profileCoordinator)
        let profileVC = profileCoordinator.navigationController
        profileVC.hidesBottomBarWhenPushed = false
        setup(vc: profileVC, title: MainCoordinatorConstants.profileTitle, imageName: MainCoordinatorConstants.profileImageName, selectedImageName: MainCoordinatorConstants.profileSelectedImageName)

        tabBarController.viewControllers = [feedVC, moviesVC, favoritesVC, profileVC]
    }

    func setup(vc: UIViewController, title: String, imageName: String, selectedImageName: String) {
        let defaultImage = UIImage(named: imageName)
        let selectedImage = UIImage(named: selectedImageName)?.withRenderingMode(.alwaysOriginal)
        vc.tabBarItem = UITabBarItem(title: title, image: defaultImage, selectedImage: selectedImage)

        let gradientTextImage = createGradientImage(size: MainCoordinatorConstants.gradientImageSize)
        vc.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor(patternImage: gradientTextImage!)], for: .selected)
        vc.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.gray], for: .normal)
    }

    private func logout() {
        logoutHandler?()
    }

  private func animateTransition(to viewController: UIViewController) {
      
      self.navigationController.viewControllers = [viewController]
    }
}

func createGradientImage(size: CGSize) -> UIImage? {
    let gradientLayer = ColorsEnum.orangeGradient
    gradientLayer.frame = CGRect(origin: .zero, size: size)

    let renderer = UIGraphicsImageRenderer(size: size)
    return renderer.image { context in
        gradientLayer.render(in: context.cgContext)
    }
}
