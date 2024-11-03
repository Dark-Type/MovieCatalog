//
//  RegisterRequest.swift
//  MovieCatalog
//
//  Created by dark type on 29.10.2024.
//

import Foundation

struct RegisterRequest: Encodable {
    let userName: String
    let name: String
    let password: String
    let email: String
    let birthDate: String
    let gender: Int
}
