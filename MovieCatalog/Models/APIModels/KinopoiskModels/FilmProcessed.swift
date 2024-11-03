//
//  FilmProcessed.swift
//  MovieCatalog
//
//  Created by dark type on 01.11.2024.
//


import UIKit

struct FilmProcessed: Identifiable {
    var id: Int
    var nameRu: String?
    var nameEn: String?
    var type: String
    var year: String
    var description: String?
    var filmLength: String?
    var countries: [Country]
    var genres: [KinopoiskGenre]
    var rating: String?
    var ratingVoteCount: Int
    var posterImage: UIImage?
}
