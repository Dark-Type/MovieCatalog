//
//  FavoritesView.swift
//  MovieCatalog
//
//  Created by dark type on 20.10.2024.
//

import SwiftUI


struct FavoritesView: View {
    @ObservedObject var viewModel: FavoriteFilmsViewModel
    var coordinator: FavoritesTabCoordinator

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if viewModel.favoriteGenres.isEmpty && viewModel.favoriteFilms.isEmpty {
                    VStack(spacing: 10) {
                        GeometryReader { geometry in
                            Image("PlaceholderImage")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geometry.size.width, height: geometry.size.height)
                                .clipped()
                        }
                        .frame(height: UIScreen.main.bounds.height * 0.55)
                        .ignoresSafeArea(edges: .top)

                        Text("Здесь пока ничего нет")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.top, 10)

                        Text("Добавьте любимые жанры и фильмы, чтобы вернуться к ним позже")
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .padding(.top, 5)

                        HStack {
                            Button(action: {
                                coordinator.navigateToFeed()
                            }) {
                                Text("Найти фильм для себя")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(ColorsEnum.orangeLinearGradient)
                                    .cornerRadius(10)
                            }
                            .frame(maxWidth: UIScreen.main.bounds.width * 0.55, alignment: .leading)
                            Spacer()
                        }
                        .padding(.top, 20)
                    }
                } else {
                    HStack {
                        Text(FavoritesViewConstants.favorites)
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .padding()
                        Spacer()
                    }
                    FavoriteGenresView(viewModel: viewModel)
                    FavoriteFilmsView(viewModel: viewModel)
                }
            }
            .frame(maxWidth: .infinity)
            .background(Color(ColorsEnum.baseDarkGrey))
        }
        .background(Color(ColorsEnum.baseDarkGrey))
        .onAppear {
            viewModel.loadFavoriteFilms()
            viewModel.loadFavoriteGenres()
        }
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
    static let poster3 = "Poster3"
    static let favorites = "Избранное"
    static let favoriteGenres = "Любимые жанры"
    static let favoriteFilms = "Любимые фильмы"
    static let brokenHeart = "BrokenHeart"
    static let filledHeart = "FilledHeart"
    static let sciFi = "Sci-Fi"
}

