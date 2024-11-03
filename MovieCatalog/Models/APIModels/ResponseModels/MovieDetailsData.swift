//
//  MovieDetails.swift
//  MovieCatalog
//
//  Created by dark type on 01.11.2024.
//

import Foundation

struct MovieDetailsData: Decodable {
    let id: String
    let name: String
    let poster: String
    let year: Int
    let country: String
    let genres: [GenreSummary]
    let reviews: [ReviewDetails]
    let time: Int
    let tagline: String
    let description: String
    let director: String
    let budget: Int
    let fees: Int
    let ageLimit: Int
}

struct ReviewDetails: Decodable {
    let id: String
    let rating: Int
    let reviewText: String
    let isAnonymous: Bool
    let createDateTime: String
    let author: AuthorDetails?
}

struct AuthorDetails: Codable {
    let userId: String?
    let nickName: String?
    let avatar: String?
}
