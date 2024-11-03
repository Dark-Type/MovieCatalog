//
//  OnboardingCoordinator.swift
//  MovieCatalog
//
//  Created by dark type on 11.10.2024.
//

import UIKit

class OnboardingCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var isLoggedIn: Bool = false
    var loginCompletionHandler: (() -> Void)?
    var registerCompletionHandler: (() -> Void)?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let welcomeViewController = WelcomeVC()
        welcomeViewController.onboardingCompletionHandler = { [weak self] in
            self?.completeLogin()
        }
        welcomeViewController.loginHandler = { [weak self] in
            self?.presentLoginVC()
        }
        welcomeViewController.registerHandler = { [weak self] in
            self?.presentRegisterVC()
        }
        navigationController.viewControllers = [welcomeViewController]
    }

    func completeLogin() {
        isLoggedIn = true
        loginCompletionHandler?()
    }

    func completeRegistration() {
        isLoggedIn = true
        registerCompletionHandler?()
    }

    private func presentLoginVC() {
        let loginViewModel = LoginVM()
        let loginVC = LoginVC(viewModel: loginViewModel)
        loginViewModel.navigationDelegate = self
        loginVC.modalPresentationStyle = .fullScreen
        loginVC.modalTransitionStyle = .crossDissolve
        navigationController.present(loginVC, animated: true, completion: nil)
    }

    private func presentRegisterVC() {
        let registerViewModel = RegisterVM()
        let registerVC = RegisterVC(viewModel: registerViewModel)
        registerViewModel.navigationDelegate = self
        registerVC.modalPresentationStyle = .fullScreen
        registerVC.modalTransitionStyle = .crossDissolve
        navigationController.present(registerVC, animated: true, completion: nil)
    }
}

extension OnboardingCoordinator: LoginVMNavigationDelegate, RegisterVMNavigationDelegate {
    func navigateToCompleteLogin() {
        completeLogin()
    }

    func navigateToCompleteRegistration() {
        completeRegistration()
    }

    func navigateToPreviousScreen() {
        navigationController.dismiss(animated: true, completion: nil)
    }
}
