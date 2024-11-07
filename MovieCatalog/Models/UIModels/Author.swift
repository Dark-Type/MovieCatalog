//
//  Author.swift
//  MovieCatalog
//
//  Created by dark type on 01.11.2024.
//


import UIKit

struct Author: Identifiable {
    var id: String
    var name: String
    var avatarURL: String
    var avatar: UIImage?
}
extension Author {
    init(from details: AuthorDetails) {
        self.id = details.userId ?? "0"
        self.name = details.nickName ?? "Anonymous"
        self.avatarURL = details.avatar ?? ""
        self.avatar = nil
    }
    static var defaultAuthor: Author {
        return Author(id: "0", name: "Anonymous", avatarURL: "", avatar: UIImage(systemName: "person.crop.circle"))
    }
}
