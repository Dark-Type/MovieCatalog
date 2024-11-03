//
//  Genre.swift
//  MovieCatalog
//
//  Created by dark type on 01.11.2024.
//


import UIKit

struct Genre: Identifiable, Codable {
    var id: String
    var name: String
    var isFavorite: Bool
}
