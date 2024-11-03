//
//  AuthService.swift
//  MovieCatalog
//
//  Created by dark type on 01.11.2024.
//

import Alamofire

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
        AF.request(url, method: .post, parameters: user, encoder: JSONParameterEncoder.default).responseDecodable(of: LoginResponse.self) { response in
            switch response.result {
            case .success(let loginResponse):
                completion(.success(loginResponse.token))
            case .failure(let error):
                completion(.failure(error))
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
