//
//  ProfileVM.swift
//  MovieCatalog
//
//  Created by dark type on 27.10.2024.
//

import UIKit

protocol ProfileViewModelDelegate: AnyObject {
    func didUpdateProfile()
}

class ProfileViewModel {
    weak var delegate: ProfileViewModelDelegate?

    var userId: String = ""
    var username: String = "" {
        didSet { trackChange(for: "username", value: username) }
    }
    var avatarImage: UIImage? {
        didSet {
            delegate?.didUpdateProfile()
        }
    }

    var email: String = "" {
        didSet { trackChange(for: "email", value: email) }
    }

    var name: String = "" {
        didSet { trackChange(for: "name", value: name) }
    }

    var birthDate: Date = .init() {
        didSet { trackChange(for: "birthDate", value: birthDate) }
    }

    var isMale: Bool = true {
        didSet { trackChange(for: "isMale", value: isMale) }
    }

    var avatarLink: String = "" {
        didSet { trackChange(for: "avatarLink", value: avatarLink) }
    }

    private(set) var changes: [String: Any] = [:]
    private var initialState: [String: Any] = [:]

    func storeInitialState() {
        initialState = currentState
    }

    func hasChangesComparedToInitialState() -> Bool {
        return !areDictionariesEqual(currentState, initialState)
    }

    private func areDictionariesEqual(_ dict1: [String: Any], _ dict2: [String: Any]) -> Bool {
        guard dict1.count == dict2.count else { return false }
        for (key, value) in dict1 {
            if let value2 = dict2[key] {
                if !("\(value)" == "\(value2)") {
                    return false
                }
            } else {
                return false
            }
        }
        return true
    }

    var currentState: [String: Any] {
        return [
            "username": username,
            "email": email,
            "name": name,
            "birthDate": birthDate,
            "isMale": isMale,
            "avatarLink": avatarLink
        ]
    }

    private func trackChange(for key: String, value: Any) {
        changes[key] = value
        delegate?.didUpdateProfile()
    }

    func fetchUserProfile(completion: @escaping () -> Void) {
        ServiceManager.shared.profileService.fetchUserProfile { [weak self] result in
            switch result {
            case .success(let userProfile):
                self?.updateProfile(with: userProfile)
                if let avatarLink = userProfile.avatarLink {
                    self?.fetchAvatarImage(from: avatarLink)
                } else {
                    print("Avatar link is nil")
                }
                completion()
            case .failure(let error):
                print("Failed to fetch user profile: \(error)")
                completion()
            }
        }
    }

    private func fetchAvatarImage(from url: String) {
        ServiceManager.shared.imageService.fetchImage(from: url) { [weak self] result in
            switch result {
            case .success(let image):
                self?.avatarImage = image
            case .failure(let error):
                print("Failed to fetch avatar image: \(error)")
            }
        }
    }

    func updateProfile(with userProfile: UserProfile) {
        userId = userProfile.id
        username = userProfile.nickName
        email = userProfile.email
        name = userProfile.name
        birthDate = ISO8601DateFormatter().date(from: userProfile.birthDate) ?? Date()
        isMale = userProfile.gender == 0
        avatarLink = userProfile.avatarLink ?? "avatarLink"
        delegate?.didUpdateProfile()
    }

    func saveProfile(completion: @escaping (Result<Void, Error>) -> Void) {
        let dateFormatter = ISO8601DateFormatter()
        let birthDateString = dateFormatter.string(from: birthDate)

        let updateRequest = UserProfile(
            id: userId,
            nickName: username,
            email: email,
            avatarLink: avatarLink,
            name: name,
            birthDate: birthDateString,
            gender: isMale ? 0 : 1
        )

        ServiceManager.shared.profileService.updateUserProfile(updateRequest) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func updateUsername(_ username: String) {
        self.username = username
    }

    func updateEmail(_ email: String) {
        self.email = email
    }

    func updateName(_ name: String) {
        self.name = name
    }

    func updateBirthDate(_ birthDate: Date) {
        self.birthDate = birthDate
    }

    func updateGender(isMale: Bool) {
        self.isMale = isMale
    }
}
