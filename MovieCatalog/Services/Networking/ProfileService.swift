//
//  ProfileService.swift
//  MovieCatalog
//
//  Created by dark type on 02.11.2024.
//

import Alamofire
import Foundation

class ProfileService {
    static let shared = ProfileService()
    private init() {}

    private let baseURL = "https://react-midterm.kreosoft.space/api"

    func fetchUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
        let url = "\(baseURL)/account/profile"

        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Token not found"])))
            return
        }

        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]

        AF.request(url, method: .get, headers: headers).responseDecodable(of: UserProfile.self) { response in
            switch response.result {
            case .success(let userProfile):
                completion(.success(userProfile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func updateUserProfile(_ profile: UserProfile, completion: @escaping (Result<Void, Error>) -> Void) {
        let url = "\(baseURL)/account/profile"

        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Token not found"])))
            return
        }

        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]

        AF.request(url, method: .put, parameters: profile, encoder: JSONParameterEncoder.default, headers: headers).response { response in
            switch response.result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
