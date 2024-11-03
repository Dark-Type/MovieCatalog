//
//  RatingView.swift
//  MovieCatalog
//
//  Created by dark type on 13.10.2024.
//

import SwiftUI

enum RatingViewConstants {
    static let title = "Рейтинг"
    static let imageName = "FavoriteStar"
    static let spacing: CGFloat = 20
    static let cornerRadius: CGFloat = 16
}

struct RatingView: View {
    let ratings: [Rating]

    let columns = [
        GridItem(.flexible(), spacing: RatingViewConstants.spacing),
        GridItem(.flexible(), spacing: RatingViewConstants.spacing),
        GridItem(.flexible(), spacing: RatingViewConstants.spacing)
    ]

    var body: some View {
        VStack {
            HStack {
                Image(RatingViewConstants.imageName)
                    .renderingMode(.template)
                    .frame(alignment: .center)

                Text(RatingViewConstants.title)
                Spacer()
            }
            .foregroundStyle(Color(ColorsEnum.subTitleGrey))
            .frame(maxWidth: .infinity)

            LazyVGrid(columns: columns, spacing: RatingViewConstants.spacing) {
                ForEach(ratings) { rating in
                    RatingSubView(image: Image(uiImage: rating.image), rating: rating.rating)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(ColorsEnum.baseGrey))
        .cornerRadius(RatingViewConstants.cornerRadius)
    }
}

#Preview {
    RatingView(ratings: [
        Rating(id: "1", rating: 10.0, image: UIImage(named: "Poster1")!),
        Rating(id: "2", rating: 8.0, image: UIImage(named: "Poster2")!),
        Rating(id: "3", rating: 9.0, image: UIImage(named: "Poster3")!),
        Rating(id: "4", rating: 8.0, image: UIImage(named: "Poster2")!),
        Rating(id: "5", rating: 9.0, image: UIImage(named: "Poster3")!)
    ])
}
