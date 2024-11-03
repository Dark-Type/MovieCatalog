//
//  HiddenFilmsService.swift
//  MovieCatalog
//
//  Created by dark type on 02.11.2024.
//


import Foundation

class HiddenFilmsService {
    static let shared = HiddenFilmsService()
    private init() {}

    private let hiddenFilmsKey = "hiddenFilms"

    func hideFilm(withId id: String) {
        var hiddenFilms = getHiddenFilms()
        hiddenFilms.insert(id)
        UserDefaults.standard.set(Array(hiddenFilms), forKey: hiddenFilmsKey)
    }

    func unhideFilm(withId id: String) {
        var hiddenFilms = getHiddenFilms()
        hiddenFilms.remove(id)
        UserDefaults.standard.set(Array(hiddenFilms), forKey: hiddenFilmsKey)
    }

    func isFilmHidden(withId id: String) -> Bool {
        return getHiddenFilms().contains(id)
    }

    func getHiddenFilms() -> Set<String> {
        let hiddenFilms = UserDefaults.standard.stringArray(forKey: hiddenFilmsKey) ?? []
        return Set(hiddenFilms)
    }
}
