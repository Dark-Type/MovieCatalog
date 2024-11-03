//
//  KinopoiskService.swift
//  MovieCatalog
//
//  Created by dark type on 01.11.2024.
//

import Alamofire
import Foundation
import UIKit

class KinopoiskService {
    static let shared = KinopoiskService()
    private init() {}

    private let baseURL = "https://kinopoiskapiunofficial.tech/api"
    private let apiKey = "885b0490-a6b5-4467-8b0d-9ecabdc07f4e"

    func searchFilmsByKeyword(keyword: String, page: Int = 1, completion: @escaping (Result<[Film], Error>) -> Void) {
        let url = "\(baseURL)/v2.1/films/search-by-keyword"
        let parameters: [String: Any] = ["keyword": keyword, "page": page]
        let headers: HTTPHeaders = ["X-API-KEY": apiKey, "Content-Type": "application/json"]

        AF.request(url, method: .get, parameters: parameters, headers: headers)
            .validate()
            .responseDecodable(of: FilmSearchResponse.self) { response in
                switch response.result {
                case .success(let filmSearchResponse):
                    if let films = filmSearchResponse.films {
                        completion(.success(films))
                    } else {
                        print("searchFilmsByKeyword Error: No films found.")
                        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No films found."])))
                    }
                case .failure(let error):
                    print("searchFilmsByKeyword Failure: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
    }

    func fetchMovieDetails(id: Int, completion: @escaping (Result<MovieDetailsResponse, Error>) -> Void) {
        let url = "\(baseURL)/v2.2/films/\(id)"
        let headers: HTTPHeaders = ["X-API-KEY": apiKey, "Content-Type": "application/json"]

        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: MovieDetailsResponse.self) { response in
                switch response.result {
                case .success(let movieDetails):
                    completion(.success(movieDetails))
                case .failure(let error):
                    print("fetchMovieDetails Failure: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
    }

    func fetchStaff(filmId: Int, completion: @escaping (Result<[StaffMember], Error>) -> Void) {
        let url = "\(baseURL)/v1/staff"
        let parameters: [String: Any] = ["filmId": filmId]
        let headers: HTTPHeaders = ["X-API-KEY": apiKey, "Content-Type": "application/json"]

        AF.request(url, method: .get, parameters: parameters, headers: headers)
            .validate()
            .responseDecodable(of: [StaffMember].self) { response in
                switch response.result {
                case .success(let staffMembers):
                    completion(.success(staffMembers))
                case .failure(let error):
                    print("fetchStaff Failure: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
    }

    func processStaff(staffMembers: [StaffMember], completion: @escaping (Result<[Author], Error>) -> Void) {
        let directors = staffMembers.filter { $0.professionKey == "DIRECTOR" }
        var authors: [Author] = []
        let group = DispatchGroup()

        for director in directors {
            group.enter()
            let posterUrl = director.posterUrl ?? ""
            ImageService.shared.fetchImage(from: posterUrl) { result in
                let avatar: UIImage?
                switch result {
                case .success(let fetchedImage):
                    avatar = fetchedImage
                case .failure(let error):
                    print("Image fetch failed for director \(director.nameRu ?? director.nameEn ?? "Unknown"): \(error.localizedDescription)")
                    avatar = UIImage(systemName: "person.crop.circle")
                }
                let author = Author(
                    id: String(director.staffId),
                    name: director.nameRu ?? director.nameEn ?? "Unknown",
                    avatarURL: director.posterUrl ?? "",
                    avatar: avatar ?? UIImage()
                )
                authors.append(author)
                group.leave()
            }
        }

        group.notify(queue: .main) {
            completion(.success(authors))
        }
    }
}
