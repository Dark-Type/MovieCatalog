//
//  MoviesResponse.swift
//  MovieCatalog
//
//  Created by dark type on 01.11.2024.
//


import Foundation

struct MoviesResponse: Decodable {
    let movies: [MovieSummary]
    let pageInfo: PageInfo
}

struct PageInfo: Decodable {
    let pageSize: Int
    let pageCount: Int
    let currentPage: Int
}
