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
    static let stackViewSpacing: CGFloat = 8
    static let profileImageSize: CGFloat = 100
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
    // MARK: - Properties

    var logoutAction: (() -> Void)?
    private var viewModel: ProfileViewModel

    private let usernameLabel = ProfileVC.createLabel(textColor: ColorsEnum.subTitleGrey)
    private let greetingLabel = ProfileVC.createGreetingLabel()
    private let profileImageView = ProfileVC.createProfileImageView()
    private let logoutButton = ProfileVC.createLogoutButton()
    private let profileBackgroundImageView = ProfileVC.createBackgroundImageView()
    private let usernameTextField = MCTextField(hintText: ProfileVCStrings.usernameHint.rawValue)
    private let emailLabel = ProfileVC.createLabel(textColor: ColorsEnum.subTitleGrey)
    private let emailTextField = MCEmailTextField(hintText: ProfileVCStrings.emailHint.rawValue)
    private let nameLabel = ProfileVC.createLabel(textColor: ColorsEnum.subTitleGrey)
    private let nameTextField = MCTextField(hintText: ProfileVCStrings.nameHint.rawValue)
    private let birthDateLabel = ProfileVC.createLabel(textColor: ColorsEnum.subTitleGrey)
    private let datePicker = MCDatePicker()
    private let switchLabel = ProfileVC.createLabel(textColor: ColorsEnum.subTitleGrey)
    private let switchButton = MCToggleView()
    private let friendsView = UIView()
    private let friendsLabel = ProfileVC.createLabel(textColor: ColorsEnum.subTitleGrey)
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let userDataSectionLabel = ProfileVC.createSectionLabel(text: "Личная информация")

    // MARK: - Initializer

    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)

        viewModel.fetchUserProfile {
            DispatchQueue.main.async {
                self.updateUI()
                self.loadFriends()
            }
        }
    }

    // MARK: - Setup Methods

    private func setupView() {
        navigationItem.title = ""
        view.backgroundColor = ColorsEnum.baseDarkGrey
        setupLabels()
        setupScrollView()
        setupContentView()
        setupProfileSection()
        setupConstraints()
        setupTapGestureToDismissKeyboardProfile()
    }

    private static func createLabel(textColor: UIColor) -> UILabel {
        let label = UILabel()
        label.textColor = textColor
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    private static func createSectionLabel(text: String) -> UILabel {
        let label = UILabel()
        label.textColor = ColorsEnum.subTitleGrey
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = text
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    private static func createGreetingLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        return label
    }

    private static func createBackgroundImageView() -> UIImageView {
        let imageView = UIImageView(image: UIImage(named: "ProfileBackground"))
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }

    private static func createProfileImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = ProfileVCConstants.profileImageSize / 2
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }

    private static func createLogoutButton() -> UIButton {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "Logout")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.backgroundColor = ColorsEnum.baseGrey.withAlphaComponent(0.5)
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }

    private func setupLabels() {
        usernameLabel.text = ProfileVCStrings.usernameHint.rawValue
        emailLabel.text = ProfileVCStrings.emailHint.rawValue
        nameLabel.text = ProfileVCStrings.nameHint.rawValue
        birthDateLabel.text = ProfileVCStrings.birthDateHint.rawValue
        switchLabel.text = ProfileVCStrings.switchHint.rawValue
        friendsLabel.text = "Мои друзья"
    }

    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentInsetAdjustmentBehavior = .never
        view.addSubview(scrollView)
    }

    private func setupContentView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
    }

    private func setupProfileSection() {
        contentView.addSubview(profileBackgroundImageView)
        contentView.addSubview(profileImageView)
        contentView.addSubview(greetingLabel)
        contentView.addSubview(logoutButton)
        contentView.addSubview(friendsView)
        contentView.addSubview(userDataSectionLabel)

        friendsView.backgroundColor = ColorsEnum.baseGrey
        friendsView.layer.cornerRadius = 10
        friendsView.translatesAutoresizingMaskIntoConstraints = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        profileImageView.addGestureRecognizer(tapGesture)
        profileImageView.isUserInteractionEnabled = true

        friendsView.addSubview(friendsLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -100),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        NSLayoutConstraint.activate([
            profileBackgroundImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            profileBackgroundImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            profileBackgroundImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            profileBackgroundImageView.heightAnchor.constraint(equalToConstant: 200)
        ])

        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            profileImageView.centerYAnchor.constraint(equalTo: profileBackgroundImageView.bottomAnchor, constant: -10),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100)
        ])

        NSLayoutConstraint.activate([
            greetingLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 20),
            greetingLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            greetingLabel.trailingAnchor.constraint(lessThanOrEqualTo: logoutButton.leadingAnchor, constant: -20)
        ])

        NSLayoutConstraint.activate([
            logoutButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            logoutButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            logoutButton.widthAnchor.constraint(equalToConstant: 40),
            logoutButton.heightAnchor.constraint(equalToConstant: 40)
        ])

        NSLayoutConstraint.activate([
            friendsView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 30),
            friendsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            friendsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            friendsView.heightAnchor.constraint(equalToConstant: 75)
        ])

        NSLayoutConstraint.activate([
            friendsLabel.centerYAnchor.constraint(equalTo: friendsView.centerYAnchor),
            friendsLabel.centerXAnchor.constraint(equalTo: friendsView.centerXAnchor, constant: -20)
        ])

        NSLayoutConstraint.activate([
            userDataSectionLabel.topAnchor.constraint(equalTo: friendsView.bottomAnchor, constant: 30),
            userDataSectionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            userDataSectionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])

        let stackView = setupStackView()
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: userDataSectionLabel.bottomAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }

    private func setupStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = ProfileVCConstants.stackViewSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false

        let elements: [UIView] = [
            usernameLabel, usernameTextField,
            emailLabel, emailTextField,
            nameLabel, nameTextField,
            birthDateLabel, datePicker,
            switchLabel, switchButton
        ]

        elements.forEach { addArrangedSubviewWithHeight($0, to: stackView) }

        return stackView
    }

    private func addArrangedSubviewWithHeight(_ view: UIView, to stackView: UIStackView) {
        stackView.addArrangedSubview(view)
        view.heightAnchor.constraint(equalToConstant: ProfileVCConstants.heightOfItems).isActive = true
    }

    // MARK: - Binding

    private func bindViewModel() {
        viewModel.delegate = self
        switchButton.delegate = self
        datePicker.delegate = self

        usernameTextField.addTarget(self, action: #selector(usernameTextFieldChanged), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(emailTextFieldChanged), for: .editingChanged)
        nameTextField.addTarget(self, action: #selector(nameTextFieldChanged), for: .editingChanged)
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
    }

    // MARK: - Update Methods

    func didUpdateProfile() {
        updateProfileImage()
        updateFields()
    }

    private func updateUI() {
        updateGreetingLabel()
        updateProfileImage()
        updateFields()
    }

    private func updateGreetingLabel() {
        greetingLabel.text = "\(getGreeting()), \(viewModel.name)!"
    }

    private func updateProfileImage() {
        profileImageView.image = viewModel.avatarImage ?? UIImage(systemName: "person.circle")
    }

    private func updateFields() {
        usernameTextField.text = viewModel.username
        emailTextField.text = viewModel.email
        nameTextField.text = viewModel.name
        datePicker.setDate(viewModel.birthDate, animated: false)
        switchButton.setIsLeftButtonOn(viewModel.isMale)
    }

    // MARK: - Actions

    @objc private func logoutButtonTapped() {
        print("logoutButtonTapped")
        ServiceManager.shared.authService.logout { [weak self] result in
            switch result {
            case .success:
                ServiceManager.shared.resetAllServices()
                self?.logoutAction?()
            case .failure(let error):
                print("Logout failed: \(error)")
            }
        }
    }

    @objc private func profileImageTapped() {
        let alert = UIAlertController(title: "Update Profile Image", message: "Enter the URL of the new profile image:", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Image URL"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak self] _ in
            if let url = alert.textFields?.first?.text, !url.isEmpty {
                self?.updateProfileImage(with: url)
            }
        }))
        present(alert, animated: true, completion: nil)
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

    private func getGreeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 6..<12:
            return "Доброе утро"
        case 12..<18:
            return "Добрый день"
        case 18..<24:
            return "Добрый вечер"
        default:
            return "Доброй ночи"
        }
    }

    private func updateProfileImage(with url: String) {
        viewModel.updateProfileImageURL(url) { [weak self] result in
            switch result {
            case .success:
                self?.viewModel.fetchAvatarImage(from: url)
            case .failure(let error):
                print("Failed to update profile image URL: \(error)")
            }
        }
    }

    // MARK: - Keyboard Handling

    private func setupTapGestureToDismissKeyboardProfile() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardAndCheckChanges))
        tapGesture.cancelsTouchesInView = false
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

    // MARK: - Alerts

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

    // MARK: - Delegate Methods

    func datePickerDidChange(_ datePicker: MCDatePicker, date: Date) {
        viewModel.updateBirthDate(date)
        showSaveChangesAlert()
    }

    func toggleViewDidChange(_ toggleView: MCToggleView, isLeftButtonOn: Bool) {
        viewModel.updateGender(isMale: isLeftButtonOn)
        showSaveChangesAlert()
    }

    // MARK: - Friends

    private func loadFriends() {
        let friends = FriendsService.shared.getFriends()

        if  friends.isEmpty || friends[0].nickName == nil && friends[0].userId == nil && friends[0].avatar == nil {
            setupNoFriendsView()
        } else {
            let friendsToLoad = Array(friends.prefix(3))
            var friendImages: [UIImage] = []

            let dispatchGroup = DispatchGroup()

            for friend in friendsToLoad {
                dispatchGroup.enter()
                if let avatarURL = friend.avatar {
                    ImageService.shared.fetchImage(from: avatarURL) { result in
                        switch result {
                        case .success(let image):
                            friendImages.append(image)
                        case .failure:
                            friendImages.append(UIImage(systemName: "person.circle")!)
                        }
                        dispatchGroup.leave()
                    }
                } else {
                    friendImages.append(UIImage(systemName: "person.circle")!)
                    dispatchGroup.leave()
                }
            }

            dispatchGroup.notify(queue: .main) {
                self.setupFriendsView(friends: friendImages)
            }
        }
    }

    private func setupNoFriendsView() {
        for view in friendsView.subviews {
            view.removeFromSuperview()
        }

        let noFriendsLabel = UILabel()
        noFriendsLabel.text = "У вас пока нет друзей"
        noFriendsLabel.textColor = .white
        noFriendsLabel.font = UIFont.systemFont(ofSize: 18)
        noFriendsLabel.translatesAutoresizingMaskIntoConstraints = false
        friendsView.addSubview(noFriendsLabel)

        NSLayoutConstraint.activate([
            noFriendsLabel.centerXAnchor.constraint(equalTo: friendsView.centerXAnchor),
            noFriendsLabel.centerYAnchor.constraint(equalTo: friendsView.centerYAnchor)
        ])
    }

    private func setupFriendsView(friends: [UIImage]) {
        for view in friendsView.subviews {
            if view !== friendsLabel {
                view.removeFromSuperview()
            }
        }

        let imageSize: CGFloat = 30
        let overlap: CGFloat = 15
        let totalWidth = imageSize + CGFloat(friends.count - 1) * (imageSize - overlap)

        let imagesContainer = UIView()
        imagesContainer.translatesAutoresizingMaskIntoConstraints = false
        friendsView.addSubview(imagesContainer)
        NSLayoutConstraint.activate([
            imagesContainer.centerYAnchor.constraint(equalTo: friendsView.centerYAnchor),
            imagesContainer.leadingAnchor.constraint(equalTo: friendsView.leadingAnchor, constant: 20),
            imagesContainer.widthAnchor.constraint(equalToConstant: totalWidth),
            imagesContainer.heightAnchor.constraint(equalToConstant: imageSize)
        ])

        for (index, friendImage) in friends.enumerated() {
            let friendImageView = UIImageView(image: friendImage)
            friendImageView.contentMode = .scaleAspectFill
            friendImageView.clipsToBounds = true
            friendImageView.layer.cornerRadius = imageSize / 2
            friendImageView.translatesAutoresizingMaskIntoConstraints = false
            imagesContainer.addSubview(friendImageView)

            NSLayoutConstraint.activate([
                friendImageView.widthAnchor.constraint(equalToConstant: imageSize),
                friendImageView.heightAnchor.constraint(equalToConstant: imageSize),
                friendImageView.leadingAnchor.constraint(equalTo: imagesContainer.leadingAnchor, constant: CGFloat(index) * (imageSize - overlap)),
                friendImageView.centerYAnchor.constraint(equalTo: imagesContainer.centerYAnchor)
            ])
        }

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openFriendsList))
        friendsView.addGestureRecognizer(tapGesture)
    }

    @objc private func openFriendsList() {
        let friendsListVC = FriendsListVC()
        friendsListVC.currentUserLogin = viewModel.username
        navigationController?.pushViewController(friendsListVC, animated: true)
    }
}
