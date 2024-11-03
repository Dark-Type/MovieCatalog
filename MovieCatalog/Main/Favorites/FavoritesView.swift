//
//  FavoritesView.swift
//  MovieCatalog
//
//  Created by dark type on 20.10.2024.
//

import SwiftUI


struct FavoritesView: View {
    @ObservedObject var viewModel: FavoriteFilmsViewModel

    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Text(FavoritesViewConstants.favorites)
                        .font(.largeTitle)
                        .padding()
                        .foregroundStyle(.white)
                    Spacer()
                }
                FavoriteGenresView(viewModel: viewModel)
                FavoriteFilmsView(viewModel: viewModel)
            }
            .background(Color(ColorsEnum.baseDarkGrey))
            .padding()
        }
        .background(Color(ColorsEnum.baseDarkGrey))
    }
}

enum FavoritesViewConstants {
    static let action = "Action"
    static let comedy = "Comedy"
    static let drama = "Drama"
    static let fightClub = "Fight Club"
    static let edgingRunner = "Edging runner"
    static let averageSoftwareDevelopmentCompany = "Average Software Development Company"
    static let releaseDate2000 = "2000"
    static let releaseDate2010 = "2010"
    static let releaseDate1999 = "1999"
    static let usa = "USA"
    static let ageRestrictionR = "R"
    static let ageRestrictionPG13 = "PG-13"
    static let timeDurationFightClub = "2h 19m"
    static let timeDurationEdgingRunner = "2h 28m"
    static let timeDurationAverageSoftwareDevelopmentCompany = "2h 16m"
    static let description = "Some description Some description Some description Some description Some description Some description"
    static let andreiTarkovsky = "Andrei Tarkovsky"
    static let poster1 = "Poster1"
    static let poster2 = "Poster2"
    static let poster3 = "Poster3"
    static let favorites = "Избранное"
    static let favoriteGenres = "Любимые жанры"
    static let favoriteFilms = "Любимые фильмы"
    static let brokenHeart = "BrokenHeart"
    static let filledHeart = "FilledHeart"
    static let sciFi = "Sci-Fi"
}

