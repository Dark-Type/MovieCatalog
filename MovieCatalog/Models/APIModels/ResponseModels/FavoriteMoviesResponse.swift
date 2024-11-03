//
//  FavoriteMoviesResponse.swift
//  MovieCatalog
//
//  Created by dark type on 01.11.2024.
//


import Foundation

struct FavoriteMoviesResponse: Decodable {
    let movies: [MovieSummary]
}
