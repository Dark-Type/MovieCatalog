//
//  Film.swift
//  MovieCatalog
//
//  Created by dark type on 01.11.2024.
//


import Foundation

struct Film: Decodable {
    let filmId: Int
    let nameRu: String?
    let nameEn: String?
    let type: String
    let year: String
    let description: String?
    let filmLength: String?
    let countries: [Country]
    let genres: [KinopoiskGenre]
    let rating: String?
    let ratingVoteCount: Int
    let posterUrl: String
    let posterUrlPreview: String
}
