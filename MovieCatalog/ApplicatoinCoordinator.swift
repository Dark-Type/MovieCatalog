//
//  ApplicatoinCoordinator.swift
//  MovieCatalog
//
//  Created by dark type on 11.10.2024.
//

import UIKit

class ApplicationCoordinator: Coordinator {
    let window: UIWindow
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController = .init()
    var isLoggedIn: Bool {
        get { UserDefaults.standard.bool(forKey: "isLoggedIn") }
        set { UserDefaults.standard.setValue(newValue, forKey: "isLoggedIn") }
    }

    private var logoutTimer: Timer?

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        if isLoggedIn {
            if let loginTimestamp = UserDefaults.standard.value(forKey: "loginTimestamp") as? Date {
                let elapsedTime = Date().timeIntervalSince(loginTimestamp)
                if elapsedTime > 1800 {
                    logoutUser()
                } else {
                    presentMainCoordinator()
                    startLogoutTimer()
                }
            } else {
                presentOnboardingCoordinator()
            }
        } else {
            presentOnboardingCoordinator()
        }
    }

    private func startLogoutTimer() {
        logoutTimer?.invalidate()
        logoutTimer = Timer.scheduledTimer(timeInterval: 1800, target: self, selector: #selector(logoutUser), userInfo: nil, repeats: false)
    }

    @objc private func logoutUser() {
        isLoggedIn = false
        // saveCurrentViewState()
        presentOnboardingCoordinator()
    }

    private func saveLoginTimestamp() {
        UserDefaults.standard.setValue(Date(), forKey: "loginTimestamp")
    }

//    private func saveCurrentViewState() {
//        if let topViewController = navigationController.topViewController {
//            // should save the vc here somehow
//            UserDefaults.standard.setValue(String(describing: type(of: topViewController)), forKey: "lastViewController")
//        }
//    }

    func presentOnboardingCoordinator() {
        let onboardingCoordinator = OnboardingCoordinator(navigationController: UINavigationController())
        onboardingCoordinator.loginCompletionHandler = { [weak self] in
            self?.isLoggedIn = true
            self?.saveLoginTimestamp()
            self?.presentMainCoordinator()
            self?.startLogoutTimer()
        }
        onboardingCoordinator.registerCompletionHandler = { [weak self] in
            self?.isLoggedIn = true
            self?.saveLoginTimestamp()
            self?.presentMainCoordinator()
            self?.startLogoutTimer()
        }
        onboardingCoordinator.start()
        childCoordinators = [onboardingCoordinator]
        window.rootViewController = onboardingCoordinator.navigationController
    }

    func presentMainCoordinator() {
        let mainCoordinator = MainCoordinator(navigationController: UINavigationController())
        mainCoordinator.start()
        mainCoordinator.logoutHandler = { [weak self] in
            self?.isLoggedIn = false
            self?.presentOnboardingCoordinator()
        }
        childCoordinators = [mainCoordinator]
        window.rootViewController = mainCoordinator.navigationController
    }
//    func presentMainCoordinator() {
//        let mainCoordinator = MainCoordinator(navigationController: UINavigationController())
//        mainCoordinator.start()
//        mainCoordinator.logoutHandler = { [weak self] in
//            self?.isLoggedIn = false
//            self?.presentOnboardingCoordinator()
//        }
//        childCoordinators = [mainCoordinator]
//        window.rootViewController = mainCoordinator.navigationController
//
//        if let lastViewControllerName = UserDefaults.standard.string(forKey: "lastViewController") {
//            if let viewControllerType = NSClassFromString(lastViewControllerName) as? UIViewController.Type {
//                let restoredViewController = viewControllerType.init()
//                mainCoordinator.navigationController.pushViewController(restoredViewController, animated: false)
//            }
//        }
//    }
}
