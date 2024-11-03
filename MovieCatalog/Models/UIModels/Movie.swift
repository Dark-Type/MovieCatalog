//
//  Movie.swift
//  MovieCatalog
//
//  Created by dark type on 25.10.2024.
//

import UIKit

class Movie: Identifiable, ObservableObject {
    var id: String
    var externalId: Int? 
    var name: String
    @Published var poster: UIImage
    @Published var year: Int
    @Published var country: String
    @Published var genres: [Genre]
    @Published var time: String
    @Published var tagline: String
    @Published var description: String
    @Published var directors: [Author]
    @Published var budget: Int
    @Published var fees: Int
    @Published var ageLimit: String
    @Published var reviews: [Review]
    @Published var ratings: [Rating]
    var isFavorite: Bool

    init(id: String, name: String, poster: UIImage, isFavorite: Bool, genres: [Genre]) {
        self.id = id
        self.name = name
        self.poster = poster
        self.isFavorite = isFavorite
        self.year = 0
        self.country = ""
        self.genres = genres
        self.time = ""
        self.tagline = ""
        self.description = ""
        self.directors = []
        self.budget = 0
        self.fees = 0
        self.ageLimit = ""
        self.reviews = []
        self.ratings = []
    }
}
