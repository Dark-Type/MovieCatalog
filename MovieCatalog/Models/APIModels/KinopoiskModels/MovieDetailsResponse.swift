//
//  MovieDetailsResponse.swift
//  MovieCatalog
//
//  Created by dark type on 02.11.2024.
//

struct MovieDetailsResponse: Decodable {
    let kinopoiskId: Int
    let kinopoiskHDId: String?
    let imdbId: String?
    let nameRu: String?
    let nameEn: String?
    let nameOriginal: String?
    let posterUrl: String?
    let posterUrlPreview: String?
    let coverUrl: String?
    let logoUrl: String?
    let reviewsCount: Int?
    let ratingGoodReview: Double?
    let ratingGoodReviewVoteCount: Int?
    let ratingKinopoisk: Double?
    let ratingKinopoiskVoteCount: Int?
    let ratingImdb: Double?
    let ratingImdbVoteCount: Int?
    let ratingFilmCritics: Double?
    let ratingFilmCriticsVoteCount: Int?
    let ratingAwait: Double?
    let ratingAwaitCount: Int?
    let ratingRfCritics: Double?
    let ratingRfCriticsVoteCount: Int?
    let webUrl: String?
    let year: Int?
    let filmLength: Int?
    let slogan: String?
    let description: String?
    let shortDescription: String?
    let editorAnnotation: String?
    let isTicketsAvailable: Bool?
    let productionStatus: String?
    let type: String?
    let ratingMpaa: String?
    let ratingAgeLimits: String?
    let hasImax: Bool?
    let has3D: Bool?
    let lastSync: String?
    let countries: [Country]
    let genres: [Genre]

    struct Country: Decodable {
        let country: String
    }

    struct Genre: Decodable {
        let genre: String
    }
}

