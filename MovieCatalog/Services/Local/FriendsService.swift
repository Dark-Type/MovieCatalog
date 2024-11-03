//
//  FriendsService.swift
//  MovieCatalog
//
//  Created by dark type on 02.11.2024.
//

import Foundation

class FriendsService {
    static let shared = FriendsService()
    private init() {}

    private let friendsKey = "friends"

    func addFriend(_ friend: AuthorDetails) {
        var friends = getFriends()
        friends.append(friend)
        saveFriends(friends)
    }

    func removeFriend(byUserId userId: String) {
        var friends = getFriends()
        friends.removeAll { $0.userId == userId }
        saveFriends(friends)
    }

    func getFriends() -> [AuthorDetails] {
        guard let data = UserDefaults.standard.data(forKey: friendsKey) else { return [] }
        let friends = try? JSONDecoder().decode([AuthorDetails].self, from: data)
        return friends ?? []
    }

    private func saveFriends(_ friends: [AuthorDetails]) {
        let data = try? JSONEncoder().encode(friends)
        UserDefaults.standard.set(data, forKey: friendsKey)
    }
}
