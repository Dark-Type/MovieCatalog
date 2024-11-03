//
//  AddReviewRequest.swift
//  MovieCatalog
//
//  Created by dark type on 01.11.2024.
//

import Foundation

struct AddReviewRequest: Codable {
    let reviewText: String
    let rating: Int
    let isAnonymous: Bool
}
