//
//  FavoriteGenresView.swift
//  MovieCatalog
//
//  Created by dark type on 27.10.2024.
//

import SwiftUI

struct FavoriteGenresView: View {
    @ObservedObject var viewModel: FavoriteFilmsViewModel

    var body: some View {
        VStack {
            HStack {
                Text(FavoritesViewConstants.favoriteGenres)
                    .font(.title2)
                    .padding()
                    .foregroundStyle(ColorsEnum.orangeLinearGradient)
                Spacer()
            }
            ForEach(viewModel.favoriteGenres, id: \.id) { genre in
                HStack {
                    Text(genre.name)
                        .foregroundStyle(.white)
                    Spacer()
                    Button(action: {
                        viewModel.toggleFavoriteGenre(genre)
                    }) {
                        Image(FavoritesViewConstants.brokenHeart).renderingMode(.template)
                            .foregroundStyle(ColorsEnum.orangeLinearGradient)
                            .padding(10)
                            .background(Color(ColorsEnum.baseDarkGrey))
                            .cornerRadius(8)
                    }
                }
                .padding()
                .background(Color(ColorsEnum.baseGrey))
                .cornerRadius(10)
                .padding(.vertical, 5)
            }
        }
    }
}
