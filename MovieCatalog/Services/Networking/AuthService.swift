//
//  AuthService.swift
//  MovieCatalog
//
//  Created by dark type on 01.11.2024.
//

import Alamofire
import Foundation

class AuthService {
    static let shared = AuthService()
    private init() {}

    private let baseURL = "https://react-midterm.kreosoft.space/api/account"

    func register(user: RegisterRequest, completion: @escaping (Result<String, Error>) -> Void) {
        let url = "\(baseURL)/register"
        AF.request(url, method: .post, parameters: user, encoder: JSONParameterEncoder.default).responseDecodable(of: RegisterResponse.self) { response in
            switch response.result {
            case .success(let registerResponse):
                completion(.success(registerResponse.token))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func login(user: LoginRequest, completion: @escaping (Result<String, Error>) -> Void) {
        let url = "\(baseURL)/login"
        print(user)
        AF.request(url, method: .post, parameters: user, encoder: JSONParameterEncoder.default).responseDecodable(of: LoginResponse.self) { response in
            switch response.result {
            case .success(let loginResponse):
                completion(.success(loginResponse.token))
            case .failure(let error):
                if let data = response.data, let jsonString = String(data: data, encoding: .utf8) {
                    if jsonString.contains("Invalid username or password") {
                        completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Invalid username or password"])))
                    } else if jsonString.contains("User not found") {
                        completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not found"])))
                    } else {
                        completion(.failure(NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "Server error, please try again later"])))
                    }
                    print(error)
                } else {
                    completion(.failure(error))
                }
            }
        }
    }

    func logout(completion: @escaping (Result<Void, Error>) -> Void) {
        let url = "\(baseURL)/logout"
        AF.request(url, method: .post).response { response in
            switch response.result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
