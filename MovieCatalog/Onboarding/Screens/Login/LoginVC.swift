//
//  LoginVC.swift
//  MovieCatalog
//
//  Created by dark type on 11.10.2024.
//

import UIKit

enum LoginVCConstants {
    static let paddingLarge: CGFloat = 35
    static let paddingSmall: CGFloat = 20
    static let paddingExtraSmall: CGFloat = 8
    static let heightOfItems: CGFloat = 50
    static let welcomeButtonTitle = "Go Back to Welcome"
    static let completeLoginButtonTitle = "Complete Login"
    static let loginButtonTitle = "Войти"
    static let loginBackgroundImageName = "LoginBackground"
    static let loginTextFieldHint = "Логин"
    static let passwordTextFieldHint = "Пароль"
    static let backgroundColor = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1)
    static let goBackImageName = "ChevronLeft"
    static let goBackLabelText = "Вход в аккаунт"
}

class LoginVC: UIViewController {
    private var viewModel: LoginVM

    init(viewModel: LoginVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let goBackButton = MCGoBackButton(image: UIImage(named: LoginVCConstants.goBackImageName), labelText: LoginVCConstants.goBackLabelText)
    private let completeLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(LoginVCConstants.completeLoginButtonTitle, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let loginButton: MCButton = {
        let button = MCButton(title: LoginVCConstants.loginButtonTitle)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: LoginVCConstants.loginBackgroundImageName))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let loginTextField: MCTextField = {
        let textField = MCTextField(hintText: LoginVCConstants.loginTextFieldHint)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: LoginVCConstants.heightOfItems).isActive = true
        return textField
    }()

    private let passwordTextField: MCTextField = {
        let textField = MCTextField(hintText: LoginVCConstants.passwordTextFieldHint)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: LoginVCConstants.heightOfItems).isActive = true
        return textField
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = LoginVCConstants.paddingExtraSmall
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupBackgroundImage()
        setupStackView()
        setupConstraints()
        setupBindings()
        setupKeyboardObservers()
    }

    private func setupView() {
        setupTapGestureToDismissKeyboard()
        view.backgroundColor = LoginVCConstants.backgroundColor
        view.addSubview(imageView)
        view.addSubview(stackView)
        view.addSubview(loginButton)
        view.addSubview(goBackButton)
        view.addSubview(completeLoginButton)

        goBackButton.button.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        completeLoginButton.addTarget(self, action: #selector(completeLogin), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }

    private func setupBackgroundImage() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 591/852)
        ])

    }

    private func setupBindings() {
        loginTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }

    @objc private func textFieldDidChange() {
        viewModel.username = loginTextField.text
        viewModel.password = passwordTextField.text
        updateLoginButtonState()
    }

    private func updateLoginButtonState() {
        loginButton.isEnabled = viewModel.areAllFieldsValid()
    }

    @objc private func dismissVC() {
        viewModel.handleDismiss()
    }

    @objc private func completeLogin() {
        viewModel.handleCompleteLogin()
    }

    @objc private func loginButtonTapped() {
        viewModel.username = loginTextField.text
        viewModel.password = passwordTextField.text
        completeLogin()
    }

    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let activeTextField = view.findFirstResponder() as? UITextField else { return }

        let keyboardHeight = keyboardFrame.height
        let textFieldFrame = activeTextField.convert(activeTextField.bounds, to: view)
        let textFieldBottomY = textFieldFrame.origin.y + textFieldFrame.height

        let safeAreaBottomInset = view.safeAreaInsets.bottom
        let visibleHeight = view.frame.height - keyboardHeight - safeAreaBottomInset

        if textFieldBottomY > visibleHeight {
            let offset = textFieldBottomY - visibleHeight
            UIView.animate(withDuration: 0.3) {
                self.view.frame.origin.y = -offset
            }
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = 0
        }
    }
}

extension LoginVC {
    private func setupStackView() {
        stackView.addArrangedSubview(loginTextField)
        stackView.addArrangedSubview(passwordTextField)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: LoginVCConstants.paddingLarge),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LoginVCConstants.paddingSmall),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -LoginVCConstants.paddingSmall),

            loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -LoginVCConstants.paddingExtraSmall),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LoginVCConstants.paddingSmall),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -LoginVCConstants.paddingSmall),
            loginButton.heightAnchor.constraint(equalToConstant: LoginVCConstants.heightOfItems),

            goBackButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LoginVCConstants.paddingSmall),
            goBackButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: LoginVCConstants.paddingSmall),
            goBackButton.widthAnchor.constraint(equalToConstant: 250),
            goBackButton.heightAnchor.constraint(equalToConstant: 60),

            completeLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            completeLoginButton.topAnchor.constraint(equalTo: goBackButton.bottomAnchor, constant: LoginVCConstants.paddingSmall)
        ])
    }
}

private extension UIView {
    func findFirstResponder() -> UIView? {
        if isFirstResponder {
            return self
        }
        for subview in subviews {
            if let firstResponder = subview.findFirstResponder() {
                return firstResponder
            }
        }
        return nil
    }
}
extension LoginVC{
    func createRoundedRectShapeLayer(for view: UIView, cornerRadius: CGFloat) -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        let path = UIBezierPath(roundedRect: view.bounds, cornerRadius: cornerRadius)
        shapeLayer.path = path.cgPath
        return shapeLayer
    }
}
