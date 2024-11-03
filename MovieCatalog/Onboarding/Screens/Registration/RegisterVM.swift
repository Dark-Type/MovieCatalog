//
//  RegisterViewModel.swift
//  MovieCatalog
//
//  Created by dark type on 13.10.2024.
//

import Foundation

protocol RegisterVMNavigationDelegate: AnyObject {
    func navigateToCompleteRegistration()
    func navigateToPreviousScreen()
}

protocol RegisterVMUIDelegate: AnyObject {
    func didUpdateRegister()
}

class RegisterVM {
    weak var navigationDelegate: RegisterVMNavigationDelegate?
    weak var uiDelegate: RegisterVMUIDelegate?

    var username: String?
    var email: String?
    var name: String?
    var password: String?
    var confirmPassword: String?
    var birthDate: Date?
    var isSwitchOn: Bool = false

    func handleCompleteRegistration() {
        guard let username = username,
              let email = email,
              let name = name,
              let password = password,
              let birthDate = birthDate else { return }

        let dateFormatter = ISO8601DateFormatter()
        let birthDateString = dateFormatter.string(from: birthDate)

        let registerRequest = RegisterRequest(
            userName: username,
            name: name,
            password: password,
            email: email,
            birthDate: birthDateString,
            gender: isSwitchOn ? 0 : 1
        )

        
        ServiceManager.shared.authService.register(user: registerRequest) { result in
            switch result {
            case .success(let token):
                UserDefaults.standard.setValue(token, forKey: "authToken")
                self.navigationDelegate?.navigateToCompleteRegistration()
            case .failure(let error):
                print("Registration failed: \(error)")
            }
        }
    }

    func handleDismiss() {
        navigationDelegate?.navigateToPreviousScreen()
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    func areAllFieldsValid() -> Bool {
        guard let username = username, !username.isEmpty,
              let email = email, isValidEmail(email),
              let name = name, !name.isEmpty,
              let password = password, !password.isEmpty,
              let confirmPassword = confirmPassword, password == confirmPassword,
              birthDate != nil else {
            return false
        }
        return true
    }

    func updateUI() {
        uiDelegate?.didUpdateRegister()
    }
}
