//
//  FourthVC.swift
//  MovieCatalog
//
//  Created by dark type on 20.10.2024.
//

import UIKit

enum ProfileVCConstants {
    static let heightOfItems: CGFloat = 50
    static let profileImageCornerRadius: CGFloat = 40
    static let profileImageBorderWidth: CGFloat = 2
    static let stackViewSpacing: CGFloat = 16
    static let profileImageSize: CGFloat = 80
    static let profileImageTopPadding: CGFloat = 20
    static let profileImageLeadingPadding: CGFloat = 20
    static let greetingLabelLeadingPadding: CGFloat = 20
    static let scrollViewTopPadding: CGFloat = 20
    static let scrollViewHorizontalPadding: CGFloat = 20
    static let logoutButtonTrailingPadding: CGFloat = -20
}

enum ProfileVCStrings: String {
    case usernameHint = "Логин"
    case emailHint = "Электронная почта"
    case nameHint = "Имя"
    case birthDateHint = "Дата рождения"
    case switchHint = "Пол"
    case logoutButtonTitle = "Logout"
    case greetingText = "Hello, Sample Name!"
}

class ProfileVC: UIViewController, ProfileViewModelDelegate, MCToggleViewDelegate, MCDatePickerDelegate {
    var logoutAction: (() -> Void)?
    private var viewModel: ProfileViewModel

    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = ColorsEnum.subTitleGrey
        return label
    }()
    private let greetingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = ColorsEnum.subTitleGrey
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let profileContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let profileBackgroundImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "ProfileBackground"))
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    

    private let usernameTextField = MCTextField(hintText: ProfileVCStrings.usernameHint.rawValue)
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.textColor = ColorsEnum.subTitleGrey
        return label
    }()

    private let emailTextField = MCEmailTextField(hintText: ProfileVCStrings.emailHint.rawValue)
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = ColorsEnum.subTitleGrey
        return label
    }()

    private let nameTextField = MCTextField(hintText: ProfileVCStrings.nameHint.rawValue)
    private let birthDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = ColorsEnum.subTitleGrey
        return label
    }()
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = ProfileVCConstants.profileImageCornerRadius
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let datePicker = MCDatePicker()
    private let switchLabel: UILabel = {
        let label = UILabel()
        label.textColor = ColorsEnum.subTitleGrey
        return label
    }()

    private let switchButton = MCToggleView()
    private let stackView = UIStackView()
    private let scrollView = UIScrollView()
    private let friendsView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = ""
        view.backgroundColor = ColorsEnum.baseDarkGrey
        setupLabels()
        setupProfileContainerView()
        setupStackView()
        setupScrollView()
        setupConstraints()
        bindViewModel()
        setupTapGestureToDismissKeyboardProfile()
        viewModel.fetchUserProfile {
            DispatchQueue.main.async {
                self.updateGreetingLabel()
            }
        }
        setupFriendsView(friendsView, friends: [UIImage(named: "Poster1")!, UIImage(named: "Poster2")!, UIImage(named: "Poster3")!])
    }

    private func bindViewModel() {
        viewModel.delegate = self
        switchButton.delegate = self
        datePicker.delegate = self

        usernameTextField.addTarget(self, action: #selector(usernameTextFieldChanged), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(emailTextFieldChanged), for: .editingChanged)
        nameTextField.addTarget(self, action: #selector(nameTextFieldChanged), for: .editingChanged)
    }

    @objc private func usernameTextFieldChanged() {
        viewModel.updateUsername(usernameTextField.text ?? "")
    }

    @objc private func emailTextFieldChanged() {
        viewModel.updateEmail(emailTextField.text ?? "")
    }

    @objc private func nameTextFieldChanged() {
        viewModel.updateName(nameTextField.text ?? "")
    }

    func datePickerDidChange(_ datePicker: MCDatePicker, date: Date) {
        viewModel.updateBirthDate(date)
        showSaveChangesAlert()
    }

    func toggleViewDidChange(_ toggleView: MCToggleView, isLeftButtonOn: Bool) {
        viewModel.updateGender(isMale: isLeftButtonOn)
        showSaveChangesAlert()
    }

    func didUpdateProfile() {
        usernameTextField.text = viewModel.username
        emailTextField.text = viewModel.email
        nameTextField.text = viewModel.name
        datePicker.setDate(viewModel.birthDate, animated: false)
        switchButton.setIsLeftButtonOn(viewModel.isMale)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchUserProfile {
            DispatchQueue.main.async {
                self.updateUI()
            }
        }
    }

    private func updateUI() {
        updateGreetingLabel()
        updateProfileImage()
        updateFields()
    }

    private func updateProfileImage() {
        if let avatarImage = viewModel.avatarImage {
            profileImageView.image = avatarImage
        } else {
            profileImageView.image = UIImage(systemName: "person.circle")
        }
    }
    private func updateFields() {
        usernameTextField.text = viewModel.username
        emailTextField.text = viewModel.email
        nameTextField.text = viewModel.name
        datePicker.setDate(viewModel.birthDate, animated: false)
        switchButton.setIsLeftButtonOn(viewModel.isMale)
    }

    private func createGradientTextLabel(text: String, font: UIFont) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = font
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false

        let size = label.bounds.size
        let gradientLayer = ColorsEnum.orangeGradient
        gradientLayer.frame = CGRect(origin: .zero, size: size)

        let renderer = UIGraphicsImageRenderer(size: size)
        let gradientImage = renderer.image { context in
            gradientLayer.render(in: context.cgContext)
        }

        label.textColor = UIColor(patternImage: gradientImage)
        return label
    }

    private func setupFriendsView(_ friendsView: UIView, friends: [UIImage]) {
        friendsView.backgroundColor = ColorsEnum.baseGrey
        friendsView.layer.cornerRadius = 10
        friendsView.translatesAutoresizingMaskIntoConstraints = false

        let padding: CGFloat = 10
        for (index, friendImage) in friends.prefix(3).enumerated() {
            let friendImageView = UIImageView(image: friendImage)
            friendImageView.contentMode = .scaleAspectFill
            friendImageView.clipsToBounds = true
            friendImageView.layer.cornerRadius = 30
            friendImageView.translatesAutoresizingMaskIntoConstraints = false
            friendsView.addSubview(friendImageView)

            NSLayoutConstraint.activate([
                friendImageView.widthAnchor.constraint(equalToConstant: 60),
                friendImageView.heightAnchor.constraint(equalToConstant: 60),
                friendImageView.leadingAnchor.constraint(equalTo: friendsView.leadingAnchor, constant: CGFloat(index) * 70 + padding),
                friendImageView.centerYAnchor.constraint(equalTo: friendsView.centerYAnchor)
            ])
        }

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openFriendsList))
        friendsView.addGestureRecognizer(tapGesture)
    }

    @objc private func openFriendsList() {
        let friendsListVC = FriendsListVC()
        navigationController?.pushViewController(friendsListVC, animated: true)
    }
    private func setupProfileContainerView() {
        if let avatarImage = viewModel.avatarImage {
            profileImageView.image = avatarImage
        } else {
            profileImageView.image = UIImage(systemName: "person.circle")
        }

        greetingLabel.text = "\(getGreeting()), \(viewModel.name)!"

        let logoutButton = UIButton(type: .custom)
        if let logoutImage = UIImage(named: "Logout")?.withRenderingMode(.alwaysTemplate) {
            logoutButton.setImage(logoutImage, for: .normal)
        } else {
            print("Logout image not found")
        }
        logoutButton.tintColor = .white
        logoutButton.backgroundColor = ColorsEnum.baseGrey
        logoutButton.layer.cornerRadius = 10
        logoutButton.clipsToBounds = true
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)

        profileContainerView.addSubview(profileImageView)
        profileContainerView.addSubview(greetingLabel)
        profileContainerView.addSubview(logoutButton)
        profileContainerView.addSubview(friendsView)

        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: profileContainerView.leadingAnchor, constant: 20),
            profileImageView.topAnchor.constraint(equalTo: profileContainerView.topAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: ProfileVCConstants.profileImageSize),
            profileImageView.heightAnchor.constraint(equalToConstant: ProfileVCConstants.profileImageSize),

            greetingLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: ProfileVCConstants.greetingLabelLeadingPadding),
            greetingLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),

            logoutButton.trailingAnchor.constraint(equalTo: profileContainerView.trailingAnchor, constant: -20),
            logoutButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            logoutButton.widthAnchor.constraint(equalToConstant: 40),
            logoutButton.heightAnchor.constraint(equalToConstant: 40),

            friendsView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10),
            friendsView.leadingAnchor.constraint(equalTo: profileContainerView.leadingAnchor, constant: 20),
            friendsView.trailingAnchor.constraint(equalTo: profileContainerView.trailingAnchor, constant: -20),
            friendsView.bottomAnchor.constraint(equalTo: profileContainerView.bottomAnchor),
            friendsView.heightAnchor.constraint(equalToConstant: 80)
        ])

        view.addSubview(profileContainerView)
        NSLayoutConstraint.activate([
            profileContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            profileContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func updateGreetingLabel() {
        greetingLabel.text = "\(getGreeting()), \(viewModel.name)!"
    }

    private func setupLogoutButtonInNavigationBar() {
        let logoutButton = UIButton(type: .custom)
        if let logoutImage = UIImage(named: "Logout")?.withRenderingMode(.alwaysTemplate) {
            logoutButton.setImage(logoutImage, for: .normal)
        } else {
            print("Logout image not found")
        }
        logoutButton.tintColor = .white
        logoutButton.backgroundColor = ColorsEnum.baseGrey
        logoutButton.layer.cornerRadius = 10
        logoutButton.clipsToBounds = true
        logoutButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)

        let barButtonItem = UIBarButtonItem(customView: logoutButton)
        navigationItem.rightBarButtonItem = barButtonItem
        navigationController?.hidesBarsOnSwipe = false
    }

    @objc private func logoutButtonTapped() {
        print("logoutButtonTapped")
        ServiceManager.shared.authService.logout { [weak self] result in
            switch result {
            case .success:
                self?.logoutAction?()
            case .failure(let error):
                print("Logout failed: \(error)")
            }
        }
    }

    private func setupLabels() {
        usernameLabel.text = ProfileVCStrings.usernameHint.rawValue
        emailLabel.text = ProfileVCStrings.emailHint.rawValue
        nameLabel.text = ProfileVCStrings.nameHint.rawValue
        birthDateLabel.text = ProfileVCStrings.birthDateHint.rawValue
        switchLabel.text = ProfileVCStrings.switchHint.rawValue

        for item in [usernameLabel, emailLabel, nameLabel, birthDateLabel, switchLabel] {
            item.font = UIFont.systemFont(ofSize: 18)
        }
    }

    private func setupStackView() {
        stackView.axis = .vertical
        stackView.spacing = ProfileVCConstants.stackViewSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false

        addArrangedSubviewWithHeight(usernameLabel)
        addArrangedSubviewWithHeight(usernameTextField)
        addArrangedSubviewWithHeight(emailLabel)
        addArrangedSubviewWithHeight(emailTextField)
        addArrangedSubviewWithHeight(nameLabel)
        addArrangedSubviewWithHeight(nameTextField)
        addArrangedSubviewWithHeight(birthDateLabel)
        addArrangedSubviewWithHeight(datePicker)
        addArrangedSubviewWithHeight(switchLabel)
        addArrangedSubviewWithHeight(switchButton)
    }

    private func addArrangedSubviewWithHeight(_ view: UIView) {
        stackView.addArrangedSubview(view)
        view.heightAnchor.constraint(equalToConstant: ProfileVCConstants.heightOfItems).isActive = true
    }

    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.contentInset.bottom = 100
        scrollView.addSubview(profileBackgroundImageView)
        scrollView.addSubview(profileContainerView)
        scrollView.addSubview(stackView)
        view.addSubview(scrollView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            profileBackgroundImageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            profileBackgroundImageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            profileBackgroundImageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),

            profileContainerView.topAnchor.constraint(equalTo: profileBackgroundImageView.bottomAnchor, constant: -40),
            profileContainerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            profileContainerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),

            stackView.topAnchor.constraint(equalTo: profileContainerView.bottomAnchor, constant: ProfileVCConstants.stackViewSpacing),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
 

    private func getGreeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 6..<12:
            return "Good Morning"
        case 12..<18:
            return "Good Day"
        case 18..<24:
            return "Good Evening"
        default:
            return "Good Night"
        }
    }
}
extension ProfileVC {
    private func setupTapGestureToDismissKeyboardProfile() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardAndCheckChanges))
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissKeyboardAndCheckChanges() {
        view.endEditing(true)
        checkForChangesAndShowAlert()
    }

    private func checkForChangesAndShowAlert() {
        if viewModel.hasChangesComparedToInitialState() {
            showSaveChangesAlert()
        }
    }

    private func showSaveChangesAlert() {
        let alert = UIAlertController(title: "Save Changes", message: "Do you want to save your changes?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak self] _ in
            self?.viewModel.saveProfile { result in
                switch result {
                case .success:
                    print("Profile updated successfully")
                case .failure(let error):
                    print("Failed to update profile: \(error)")
                }
            }
        }))
        present(alert, animated: true, completion: nil)
    }
}
