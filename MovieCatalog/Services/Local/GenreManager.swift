//
//  GenresManager.swift
//  MovieCatalog
//
//  Created by dark type on 01.11.2024.
//

import Foundation

class GenreManager {
    static let shared = GenreManager()
    private init() {}

    var userLogin: String?

    private func userDefaultsKey() -> String {
        guard let userLogin = userLogin else { return "" }
        return "favoriteGenres_\(userLogin)"
    }

    func toggleFavoriteStatus(for genre: Genre) {
        var favoriteGenres = loadFavoriteGenres()
        if let index = favoriteGenres.firstIndex(where: { $0.id == genre.id }) {
            favoriteGenres.remove(at: index)
        } else {
            var newGenre = genre
            newGenre.isFavorite = true
            favoriteGenres.append(newGenre)
        }
        saveFavoriteGenres(favoriteGenres)
    }

    private func saveFavoriteGenres(_ genres: [Genre]) {
        let key = userDefaultsKey()
        if let data = try? JSONEncoder().encode(genres) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    func loadFavoriteGenres() -> [Genre] {
        let key = userDefaultsKey()
        if let data = UserDefaults.standard.data(forKey: key),
           let genres = try? JSONDecoder().decode([Genre].self, from: data) {
            return genres
        }
        return []
    }

    func isFavorite(genre: Genre) -> Bool {
        let favoriteGenres = loadFavoriteGenres()
        return favoriteGenres.contains(where: { $0.id == genre.id })
    }

    func reset() {
        let key = userDefaultsKey()
        UserDefaults.standard.removeObject(forKey: key)
        userLogin = ""
    }
}
