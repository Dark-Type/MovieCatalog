//
//  ViewController.swift
//  MovieCatalog
//
//  Created by dark type on 11.10.2024.
//

import UIKit

enum WelcomeVCStrings: String {
    case loginButtonTitle = "Войти в аккаунт"
    case registerButtonTitle = "Зарегистрироваться"
    case backgroundImageName = "WelcomeBackground"
    case welcomeText = "Добро пожаловать в MovieCatalog"
}

enum WelcomeVCConstants {
    static let buttonHeight: CGFloat = 50
    static let buttonTopPadding: CGFloat = 40
    static let buttonSidePadding: CGFloat = 20
    static let buttonSpacing: CGFloat = 10
    static let stackViewBottomPadding: CGFloat = 20
    static let viewBackgroundColor = ColorsEnum.baseGrey
    static let welcomeLabelSidePadding: CGFloat = 30
}

class WelcomeVC: UIViewController {
    var onboardingCompletionHandler: (() -> Void)?
    var loginHandler: (() -> Void)?
    var registerHandler: (() -> Void)?

    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = WelcomeVCStrings.welcomeText.rawValue
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 36)
        label.textAlignment = .left
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let loginButton: MCButton = {
        let button = MCButton(title: WelcomeVCStrings.loginButtonTitle.rawValue, isActive: true)
        button.heightAnchor.constraint(equalToConstant: WelcomeVCConstants.buttonHeight).isActive = true
        return button
    }()

    private let registerButton: MCButton = {
        let button = MCButton(title: WelcomeVCStrings.registerButtonTitle.rawValue, fontColor: .white)
        button.heightAnchor.constraint(equalToConstant: WelcomeVCConstants.buttonHeight).isActive = true
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupBackgroundImage()
        setupWelcomeLabel()
        setupButtons()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addGradientToLoginButton()
    }

    @objc private func openLoginVC() {
        loginHandler?()
    }

    @objc private func openRegisterVC() {
        registerHandler?()
    }

    private func addGradientToLoginButton() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        loginButton.addOrangeGradient()
        CATransaction.commit()
    }
}

extension WelcomeVC {
    private func setupView() {
        view.backgroundColor = WelcomeVCConstants.viewBackgroundColor
    }

    private func setupBackgroundImage() {
        let backgroundImage = UIImageView(image: UIImage(named: WelcomeVCStrings.backgroundImageName.rawValue))
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundImage)

        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImage.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
    }

    private func setupWelcomeLabel() {
        view.addSubview(welcomeLabel)

        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: WelcomeVCConstants.welcomeLabelSidePadding),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -WelcomeVCConstants.welcomeLabelSidePadding)
        ])
    }

    private func setupButtons() {
        let stackView = UIStackView(arrangedSubviews: [loginButton, registerButton])
        stackView.axis = .vertical
        stackView.spacing = WelcomeVCConstants.buttonSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -WelcomeVCConstants.stackViewBottomPadding),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: WelcomeVCConstants.buttonSidePadding),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -WelcomeVCConstants.buttonSidePadding)
        ])

        loginButton.addTarget(self, action: #selector(openLoginVC), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(openRegisterVC), for: .touchUpInside)
    }
}
