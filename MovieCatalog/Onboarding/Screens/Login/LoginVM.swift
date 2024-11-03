//
//  LoginVIewModel.swift
//  MovieCatalog
//
//  Created by dark type on 13.10.2024.
//

import Foundation

protocol LoginVMNavigationDelegate: AnyObject {
    func navigateToCompleteLogin()
    func navigateToPreviousScreen()
}

class LoginVM {
    weak var navigationDelegate: LoginVMNavigationDelegate?
    var username: String?
    var password: String?

    func areAllFieldsValid() -> Bool {
        return !(username?.isEmpty ?? true) && !(password?.isEmpty ?? true)
    }

    func handleCompleteLogin() {
        guard let username = username, let password = password else { return }

        let loginRequest = LoginRequest(username: username, password: password)

        ServiceManager.shared.authService.login(user: loginRequest) { result in
            switch result {
            case .success(let token):
                UserDefaults.standard.setValue(token, forKey: "authToken")
                self.navigationDelegate?.navigateToCompleteLogin()
            case .failure(let error):
                print("Login failed: \(error)")
            }
        }
    }

    func handleDismiss() {
        navigationDelegate?.navigateToPreviousScreen()
    }
}
