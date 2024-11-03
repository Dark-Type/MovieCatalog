//
//  MovieSummary.swift
//  MovieCatalog
//
//  Created by dark type on 01.11.2024.
//

import Foundation

struct MovieSummary: Decodable {
    let id: String
    let name: String
    let poster: String
    let year: Int
    let country: String
    let genres: [GenreSummary]
    let reviews: [ReviewSummary]
}

struct GenreSummary: Decodable {
    let id: String
    let name: String
}

struct ReviewSummary: Decodable {
    let id: String
    let rating: Double
}
