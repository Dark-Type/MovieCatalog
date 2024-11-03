//
//  MovieGenresView.swift
//  MovieCatalog
//
//  Created by dark type on 13.10.2024.
//

import SwiftUI

enum GenresViewConstants {
    static let title = "Жанры"
    static let imageName = "Label"
    static let spacing: CGFloat = 10
    static let padding: CGFloat = 16
    static let cornerRadius: CGFloat = 16
    static let itemCornerRadius: CGFloat = 8
    static let minColumnWidth: CGFloat = 100
}

struct GenresView: View {
    let genres: [Genre]

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(GenresViewConstants.imageName)
                    .renderingMode(.template)
                Text(GenresViewConstants.title)
            }
            .foregroundStyle(Color(ColorsEnum.subTitleGrey))

            LazyVGrid(columns: [GridItem(.adaptive(minimum: GenresViewConstants.minColumnWidth))], spacing: GenresViewConstants.spacing) {
                ForEach(genres) { genre in
                    Text(genre.name)
                        .padding()
                        .background(
                            genre.isFavorite ?
                            AnyView(ColorsEnum.orangeLinearGradient) :
                            AnyView(Color(ColorsEnum.baseDarkGrey))
                        )
                        .cornerRadius(GenresViewConstants.itemCornerRadius)
                }
                .foregroundStyle(.white)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(GenresViewConstants.padding)
        .background(Color(ColorsEnum.baseGrey))
        .cornerRadius(GenresViewConstants.cornerRadius)
    }
}

#Preview {
    GenresView(genres: [
        Genre(id: "1", name: "aboba", isFavorite: false),
        Genre(id: "2", name: "comedy", isFavorite: true),
        Genre(id: "3", name: "Fantasy", isFavorite: false)
    ])
}
