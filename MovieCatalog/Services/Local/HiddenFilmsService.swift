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

    var userLogin: String?

    private func hiddenFilmsKey() -> String {
        guard let userLogin = userLogin else { return "" }
        return "hiddenFilms_\(userLogin)"
    }

    func hideFilm(withId id: String) {
        var hiddenFilms = getHiddenFilms()
        hiddenFilms.insert(id)
        UserDefaults.standard.set(Array(hiddenFilms), forKey: hiddenFilmsKey())
    }

    func unhideFilm(withId id: String) {
        var hiddenFilms = getHiddenFilms()
        hiddenFilms.remove(id)
        UserDefaults.standard.set(Array(hiddenFilms), forKey: hiddenFilmsKey())
    }

    func isFilmHidden(withId id: String) -> Bool {
        return getHiddenFilms().contains(id)
    }

    func getHiddenFilms() -> Set<String> {
        let hiddenFilms = UserDefaults.standard.stringArray(forKey: hiddenFilmsKey()) ?? []
        return Set(hiddenFilms)
    }

    func reset() {
        let key = hiddenFilmsKey()
        UserDefaults.standard.removeObject(forKey: key)
        userLogin = ""
    }
}
