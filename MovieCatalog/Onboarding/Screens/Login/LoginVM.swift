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
    var errorMessage: String?

    func areAllFieldsValid() -> Bool {
        return !(username?.isEmpty ?? true) && !(password?.isEmpty ?? true)
    }

    func handleCompleteLogin(completion: @escaping (Bool) -> Void) {
        guard let username = username, let password = password else {
            completion(false)
            return
        }

        let loginRequest = LoginRequest(username: username, password: password)

        ServiceManager.shared.authService.login(user: loginRequest) { result in
            switch result {
            case .success(let token):
                UserDefaults.standard.setValue(token, forKey: "authToken")
                UserDefaults.standard.setValue(username, forKey: "userNickname")
                ServiceManager.shared.setUserLogin(username)
                self.navigationDelegate?.navigateToCompleteLogin()
                completion(true)
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                completion(false)
            }
        }
    }

    func handleDismiss() {
        navigationDelegate?.navigateToPreviousScreen()
    }
}
