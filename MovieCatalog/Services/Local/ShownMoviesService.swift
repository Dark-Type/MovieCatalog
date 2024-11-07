//
//  ShownMoviesService.swift
//  MovieCatalog
//
//  Created by dark type on 06.11.2024.
//

import Foundation

class ShownMoviesService {
    static let shared = ShownMoviesService()
    private init() {}

    var userLogin: String?

    private func shownMoviesKey() -> String {
        guard let userLogin = userLogin else { return "" }
        return "shownMovies_\(userLogin)"
    }

    func addShownMovie(_ movieId: String) {
        var shownMovies = getShownMovies()
        shownMovies.insert(movieId)
        saveShownMovies(shownMovies)
    }

    func getShownMovies() -> Set<String> {
        let key = shownMoviesKey()
        let shownMovies = UserDefaults.standard.stringArray(forKey: key) ?? []
        return Set(shownMovies)
    }

    private func saveShownMovies(_ shownMovies: Set<String>) {
        let key = shownMoviesKey()
        UserDefaults.standard.set(Array(shownMovies), forKey: key)
    }

    func reset() {
        let key = shownMoviesKey()
        UserDefaults.standard.removeObject(forKey: key)
        userLogin = ""
    }
}
