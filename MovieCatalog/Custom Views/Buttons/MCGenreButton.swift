//
//  MCGenreButton.swift
//  MovieCatalog
//
//  Created by dark type on 03.11.2024.
//

import Foundation
class MCGenreButton: MCButton {
    var genre: Genre

    init(genre: Genre) {
        self.genre = genre
        let isFavorite = GenreManager.shared.isFavorite(genre: genre)
        super.init(title: genre.name, fontSize: 14, isActive: isFavorite, fontColor: .white)
        addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        updateAppearance()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func toggleFavorite() {
        print("Toggling favorite for genre: \(genre.name)")
        GenreManager.shared.toggleFavoriteStatus(for: genre)
        updateAppearance()
    }

    func updateAppearance() {
        let isFavorite = GenreManager.shared.isFavorite(genre: genre)
        print("Updating appearance for genre: \(genre.name), isFavorite: \(isFavorite)")
        setTitleColor(isFavorite ? .white : MCButtonConstants.defaultFontColor, for: .normal)
        if (isFavorite) {
            addOrangeGradient()
        } else {
            deleteOrangeGradient()
            setupSolidColorBackground(color: MCButtonConstants.defaultBackgroundColor)
        }
    }
}
