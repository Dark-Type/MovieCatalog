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

    var userLogin: String?

    private func friendsKey() -> String {
        guard let userLogin = userLogin else { return "" }
        return "friends_\(userLogin)"
    }

    func addFriend(_ friend: AuthorDetails) {
        var friends = getFriends()
        if !friends.contains(where: { $0.userId == friend.userId }) {
            friends.append(friend)
            saveFriends(friends)
            print("Friend added: \(friend.nickName ?? "Unknown")")
        } else {
            print("Friend already exists: \(friend.nickName ?? "Unknown")")
        }
    }

    func removeFriend(byUserId friendId: String) {
        var friends = getFriends()
        friends.removeAll { $0.userId == friendId }
        saveFriends(friends)
    }

    func getFriends() -> [AuthorDetails] {
        let key = friendsKey()
        guard let data = UserDefaults.standard.data(forKey: key) else { return [] }
        let friends = try? JSONDecoder().decode([AuthorDetails].self, from: data)
        return friends ?? []
    }

    private func saveFriends(_ friends: [AuthorDetails]) {
        let key = friendsKey()
        let data = try? JSONEncoder().encode(friends)
        UserDefaults.standard.set(data, forKey: key)
    }

    func reset() {
        let key = friendsKey()
        UserDefaults.standard.removeObject(forKey: key)
        userLogin = ""
    }
}
