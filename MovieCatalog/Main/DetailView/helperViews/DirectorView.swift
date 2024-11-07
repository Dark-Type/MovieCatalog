//
//  MovieDirectorView.swift
//  MovieCatalog
//
//  Created by dark type on 13.10.2024.
//

import SwiftUI

enum DirectorViewConstants {
    static let spacing: CGFloat = 10
    static let cornerRadius: CGFloat = 16
    static let itemCornerRadius: CGFloat = 8
    static let itemImageSize: CGFloat = 100
    static let padding: CGFloat = 16
    static let titleSingle = "Режиссёр"
    static let titleMultiple = "Режиссёры"
    static let imageName = "Money"
    static let defaultImageName = "person.circle"
}
struct DirectorView: View {
    let authors: [Author]

    var body: some View {
        VStack(alignment: .leading, spacing: DirectorViewConstants.spacing) {
            HStack {
                Image(DirectorViewConstants.imageName)
                    .renderingMode(.template)
                    .frame(alignment: .center)

                Text(authors.count == 1 ? DirectorViewConstants.titleSingle : DirectorViewConstants.titleMultiple)
            }
            .foregroundStyle(Color(ColorsEnum.subTitleGrey))

            VStack(spacing: DirectorViewConstants.spacing) {
                ForEach(authors, id: \.id) { author in
                    DirectorItemView(author: author)
                        .frame(maxWidth: .infinity)
                        .background(Color(ColorsEnum.baseGrey))
                        .cornerRadius(DirectorViewConstants.itemCornerRadius)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(ColorsEnum.baseGrey))
        .cornerRadius(DirectorViewConstants.cornerRadius)
    }
}

struct DirectorItemView: View {
    let author: Author

    var body: some View {
        HStack {
            if let avatar = author.avatar {
                Image(uiImage: avatar)
                    .resizable()
                    .scaledToFit()
                    .frame(width: DirectorViewConstants.itemImageSize, height: DirectorViewConstants.itemImageSize)
                    .clipShape(Circle())
            } else {
                Image(systemName: DirectorViewConstants.defaultImageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: DirectorViewConstants.itemImageSize, height: DirectorViewConstants.itemImageSize)
                    .clipShape(Circle())
            }
            Text(author.name)
                .foregroundStyle(.white)
                .font(.headline)
                .fixedSize(horizontal: false, vertical: true)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(ColorsEnum.baseDarkGrey))
        .cornerRadius(DirectorViewConstants.itemCornerRadius)
    }
}

