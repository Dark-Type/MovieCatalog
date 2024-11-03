//
//  MoviesGeneral.swift
//  MovieCatalog
//
//  Created by dark type on 01.11.2024.
//

import UIKit

struct MoviesGeneral: Identifiable {
    var id: String
    var name: String
    var poster: UIImage
    var genres: [Genre]
    var rating: Double
    var isFavorite: Bool
}
