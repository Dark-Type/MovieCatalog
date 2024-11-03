//
//  ReviewService.swift
//  MovieCatalog
//
//  Created by dark type on 01.11.2024.
//

import Alamofire
import Foundation

class ReviewService {
    static let shared = ReviewService()
    private init() {}

    private let baseURL = "https://react-midterm.kreosoft.space/api"

    func addReview(movieId: String, review: AddReviewRequest, completion: @escaping (Result<Void, Error>) -> Void) {
        let url = "\(baseURL)/movie/\(movieId)/review/add"
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Token not found"])))
            return
        }

        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]

        AF.request(url, method: .post, parameters: review, encoder: JSONParameterEncoder.default, headers: headers).response { response in
            switch response.result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func editReview(movieId: String, reviewId: String, review: AddReviewRequest, completion: @escaping (Result<Void, Error>) -> Void) {
        let url = "\(baseURL)/movie/\(movieId)/review/\(reviewId)/edit"
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Token not found"])))
            return
        }

        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]

        AF.request(url, method: .put, parameters: review, encoder: JSONParameterEncoder.default, headers: headers).response { response in
            switch response.result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func deleteReview(movieId: String, reviewId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let url = "\(baseURL)/movie/\(movieId)/review/\(reviewId)/delete"
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Token not found"])))
            return
        }

        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]

        AF.request(url, method: .delete, headers: headers).response { response in
            switch response.result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
