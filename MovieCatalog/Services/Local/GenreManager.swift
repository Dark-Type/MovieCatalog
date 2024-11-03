//
//  GenresManager.swift
//  MovieCatalog
//
//  Created by dark type on 01.11.2024.
//

import Foundation

class GenreManager {
    static let shared = GenreManager()
    private init() {
        loadFavoriteGenres()
    }

    private let userDefaultsKey = "favoriteGenres"
    private(set) var favoriteGenres: [Genre] = []

    func toggleFavoriteStatus(for genre: Genre) {
        if let index = favoriteGenres.firstIndex(where: { $0.id == genre.id }) {
            favoriteGenres.remove(at: index)
        } else {
            var newGenre = genre
            newGenre.isFavorite = true
            favoriteGenres.append(newGenre)
        }
        saveFavoriteGenres()
    }

    private func saveFavoriteGenres() {
        if let data = try? JSONEncoder().encode(favoriteGenres) {
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        }
    }

    private func loadFavoriteGenres() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let genres = try? JSONDecoder().decode([Genre].self, from: data) {
            favoriteGenres = genres
        }
    }

    func isFavorite(genre: Genre) -> Bool {
        return favoriteGenres.contains(where: { $0.id == genre.id })
    }
}
