//
//  FavoriteFilmsView.swift
//  MovieCatalog
//
//  Created by dark type on 27.10.2024.
//

import SwiftUI

struct FavoriteFilmsView: View {
    @ObservedObject var viewModel: FavoriteFilmsViewModel
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(FavoritesViewConstants.favoriteFilms)
                    .font(.title2)
                    .foregroundStyle(ColorsEnum.orangeLinearGradient)
                    .padding()
                Spacer()
            }
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(viewModel.favoriteFilms) { film in
                    Button(action: {
                        viewModel.selectMovie(film)
                    }) {
                        ZStack(alignment: .topLeading) {
                            Image(uiImage: film.poster)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 150)
                            HStack {
                                Text(String(format: "%.1f", film.rating))
                                    .font(.headline)
                                    .padding(5)
                                    .background(colorForRating(film.rating))
                                    .foregroundColor(.white)
                                    .cornerRadius(5)
                                    .padding(5)
                                    .fixedSize(horizontal: true, vertical: false)
                            }
                            .padding(5)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding()
        }
    }

    private func colorForRating(_ rating: Double) -> Color {
        switch rating {
        case 0..<5:
            return .red
        case 5..<7:
            return .yellow
        case 7..<9:
            return .mint
        case 9...10:
            return .green
        default:
            return .gray
        }
    }
}
