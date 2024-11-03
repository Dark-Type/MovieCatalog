//
//  BoxOfficeResponse.swift
//  MovieCatalog
//
//  Created by dark type on 01.11.2024.
//

import Foundation

struct BoxOfficeResponse: Decodable {
    let total: Int
    let items: [BoxOfficeItem]
}

struct BoxOfficeItem: Decodable {
    let type: String
    let amount: Int
    let currencyCode: String
    let name: String
    let symbol: String
}
