//
//  StaffMember.swift
//  MovieCatalog
//
//  Created by dark type on 01.11.2024.
//

import Foundation

struct StaffMember: Decodable {
    let staffId: Int
    let nameRu: String?
    let nameEn: String?
    let description: String?
    let posterUrl: String?
    let professionText: String
    let professionKey: String
}
