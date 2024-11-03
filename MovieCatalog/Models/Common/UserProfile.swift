//
//  UserProfile.swift
//  MovieCatalog
//
//  Created by dark type on 30.10.2024.
//

import Foundation

struct UserProfile: Codable {
    let id: String
    let nickName: String
    let email: String
    let avatarLink: String?
    let name: String
    let birthDate: String
    let gender: Int
}
