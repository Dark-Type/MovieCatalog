//
//  RegisterVC.swift
//  MovieCatalog
//
//  Created by dark type on 11.10.2024.
//

import UIKit

enum RegisterVCStrings: String {
    case registerButtonTitle = "Зарегистрироваться"
    case backgroundImageName = "RegisterBackground"
    case usernameHint = "Логин"
    case emailHint = "Электронная почта"
    case nameHint = "Имя"
    case passwordHint = "Пароль"
    case confirmPasswordHint = "Подтвердить пароль"
    case completeRegisterButtonTitle = "Complete Registration"
    case goBackImageName = "ChevronLeft"
    case lableText = "Регистрация"
}

enum RegisterVCConstants {
    static let paddingLarge: CGFloat = 35
    static let paddingSmall: CGFloat = 20
    static let paddingExtraSmall: CGFloat = 8
    static let heightOfItems: CGFloat = 50
    static let viewBackgroundColor = ColorsEnum.baseDarkGrey
}



class RegisterVC: UIViewController {
    var viewModel: RegisterVM

    init(viewModel: RegisterVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let goBackButton = MCGoBackButton(image: UIImage(named: RegisterVCStrings.goBackImageName.rawValue), labelText: RegisterVCStrings.lableText.rawValue)
    private let completeRegisterButton = UIButton(type: .system)
    private let registerButton = MCButton(title: RegisterVCStrings.registerButtonTitle.rawValue)
    private let imageView = UIImageView(image: UIImage(named: RegisterVCStrings.backgroundImageName.rawValue))
    private let usernameTextField = MCTextField(hintText: RegisterVCStrings.usernameHint.rawValue)
    private let emailTextField = MCEmailTextField(hintText: RegisterVCStrings.emailHint.rawValue)
    private let nameTextField = MCTextField(hintText: RegisterVCStrings.nameHint.rawValue)
    private let passwordTextField = MCPasswordTextField(hintText: RegisterVCStrings.passwordHint.rawValue)
    private let confirmPasswordTextField = MCPasswordTextField(hintText: RegisterVCStrings.confirmPasswordHint.rawValue)
    private let datePicker = MCDatePicker()
    private let switchButton = MCToggleView()
    private let stackView = UIStackView()

    override func viewDidLoad() {
           super.viewDidLoad()
           setupView()
           setupButtons()
           setupTextFields()
           setupStackView()
           setupConstraints()
           setupKeyboardObservers()
           setupTapGestureToDismissKeyboard()
           bindViewModel()
       }

       private func bindViewModel() {
           viewModel.uiDelegate = self
           switchButton.delegate = self
           datePicker.delegate = self

           usernameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
           emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
           nameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
           passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
           confirmPasswordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
       }
    @objc private func textFieldDidChange() {
         viewModel.username = usernameTextField.text
         viewModel.email = emailTextField.text
         viewModel.name = nameTextField.text
         viewModel.password = passwordTextField.text
         viewModel.confirmPassword = confirmPasswordTextField.text
     }

    private func updateRegisterButtonState() {
        if viewModel.areAllFieldsValid() {
            registerButton.isEnabled = true
            registerButton.addOrangeGradient()
        } else {
            registerButton.isEnabled = true
            registerButton.deleteOrangeGradient()
            registerButton.backgroundColor = ColorsEnum.baseGrey
        }
    }


    @objc private func goBackButtonTapped() {
        viewModel.handleDismiss()
    }

    @objc private func registerButtonTapped() {
           storeUserData()
           if viewModel.areAllFieldsValid() {
               viewModel.handleCompleteRegistration()
           } else {
               showValidationError("Please ensure all fields are filled, the email is valid, and the passwords match.")
           }
       }

        
    private func storeUserData() {
        viewModel.username = usernameTextField.text
        viewModel.email = emailTextField.text
        viewModel.name = nameTextField.text
        viewModel.password = passwordTextField.text
        viewModel.confirmPassword = confirmPasswordTextField.text
        viewModel.birthDate = datePicker.getDate()
        viewModel.isSwitchOn = switchButton.getIsLeftButtonOn()
    }


    @objc private func completeRegisterButtonTapped() {
        viewModel.handleCompleteRegistration()
    }
    

    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let activeTextField = view.findFirstResponder() as? UITextField else { return }

        let keyboardHeight = keyboardFrame.height
        let textFieldFrame = activeTextField.convert(activeTextField.bounds, to: view)
        let textFieldBottomY = textFieldFrame.origin.y + textFieldFrame.height * 4

        if textFieldBottomY > (view.frame.height - keyboardHeight) {
            let offset = textFieldBottomY - (view.frame.height - keyboardHeight)
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

extension RegisterVC: MCToggleViewDelegate, MCDatePickerDelegate, RegisterVMUIDelegate {
    func datePickerDidChange(_ datePicker: MCDatePicker, date: Date) {
        viewModel.birthDate = date
    }

    func toggleViewDidChange(_ toggleView: MCToggleView, isLeftButtonOn: Bool) {
        viewModel.isSwitchOn = isLeftButtonOn
    }

    func didUpdateRegister() {
        // Update UI
    }
}
extension RegisterVC {
    private func setupView() {
        view.backgroundColor = RegisterVCConstants.viewBackgroundColor
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        view.addSubview(stackView)
        view.addSubview(registerButton)
        view.addSubview(goBackButton)
        view.addSubview(completeRegisterButton)
    }

    private func setupButtons() {
        goBackButton.button.addTarget(self, action: #selector(goBackButtonTapped), for: .touchUpInside)

        completeRegisterButton.setTitle(RegisterVCStrings.completeRegisterButtonTitle.rawValue, for: .normal)
        completeRegisterButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        completeRegisterButton.heightAnchor.constraint(equalToConstant: RegisterVCConstants.heightOfItems).isActive = true
        completeRegisterButton.translatesAutoresizingMaskIntoConstraints = false
        completeRegisterButton.addTarget(self, action: #selector(completeRegisterButtonTapped), for: .touchUpInside)

        registerButton.heightAnchor.constraint(equalToConstant: RegisterVCConstants.heightOfItems).isActive = true
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        registerButton.isEnabled = true
    }
    private func setupTextFields() {
        usernameTextField.heightAnchor.constraint(equalToConstant: RegisterVCConstants.heightOfItems).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: RegisterVCConstants.heightOfItems).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: RegisterVCConstants.heightOfItems).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: RegisterVCConstants.heightOfItems).isActive = true
        confirmPasswordTextField.heightAnchor.constraint(equalToConstant: RegisterVCConstants.heightOfItems).isActive = true
        datePicker.heightAnchor.constraint(equalToConstant: RegisterVCConstants.heightOfItems).isActive = true
        switchButton.heightAnchor.constraint(equalToConstant: RegisterVCConstants.heightOfItems).isActive = true

        usernameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        nameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        confirmPasswordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }

    private func setupStackView() {
        stackView.axis = .vertical
        stackView.spacing = RegisterVCConstants.paddingExtraSmall
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(usernameTextField)
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(nameTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(confirmPasswordTextField)
        stackView.addArrangedSubview(datePicker)
        stackView.addArrangedSubview(switchButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.37),

            stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: RegisterVCConstants.paddingLarge),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: RegisterVCConstants.paddingSmall),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -RegisterVCConstants.paddingSmall),

            registerButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -RegisterVCConstants.paddingExtraSmall),
            registerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: RegisterVCConstants.paddingSmall),
            registerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -RegisterVCConstants.paddingSmall),

            goBackButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: RegisterVCConstants.paddingSmall),
            goBackButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: RegisterVCConstants.paddingSmall),
            goBackButton.widthAnchor.constraint(equalToConstant: 250),
            goBackButton.heightAnchor.constraint(equalToConstant: 60),

            completeRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            completeRegisterButton.topAnchor.constraint(equalTo: goBackButton.bottomAnchor, constant: RegisterVCConstants.paddingSmall)
        ])
    }

    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
extension RegisterVC {
    private func showValidationError(_ message: String) {
        let alertController = UIAlertController(title: "Validation Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
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
