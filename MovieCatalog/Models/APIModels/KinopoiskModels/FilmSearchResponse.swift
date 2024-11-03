//
//  FilmSearchResponse.swift
//  MovieCatalog
//
//  Created by dark type on 01.11.2024.
//


import Foundation

struct FilmSearchResponse: Decodable {
    let keyword: String
    let pagesCount: Int
    let searchFilmsCountResult: Int
    let films: [Film]?
}
