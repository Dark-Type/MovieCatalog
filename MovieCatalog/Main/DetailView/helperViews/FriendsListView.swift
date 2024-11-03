//
//  MovieFriendsListView.swift
//  MovieCatalog
//
//  Created by dark type on 13.10.2024.
//

import SwiftUI

enum FriendsListViewConstants {
    static let spacing: CGFloat = 20
    static let imageSize: CGFloat = 32
    static let imageOffset: CGFloat = 20
    static let padding: CGFloat = 16
    static let cornerRadius: CGFloat = 16
    static let friendsCountTextMultiple = "нравится %d вашим друзьям"
    static let friendsCountTextSingle = "нравится %d вашему другу"
    static let noFriendsText = "Ваши друзья еще не оценили"
}

struct FriendsListView: View {
    var friendsCount: Int
    var images: [Image]

    init(friendsCount: Int = 3, images: [Image] = []) {
        self.friendsCount = friendsCount
        self.images = images.isEmpty ? [
            Image("Poster1"),
            Image("Poster2"),
            Image("Poster3")
        ] : images
    }

    var body: some View {
        HStack(spacing: FriendsListViewConstants.spacing) {
            ZStack {
                ForEach(Array(images.enumerated()), id: \.offset) { index, image in
                    image
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: FriendsListViewConstants.imageSize, height: FriendsListViewConstants.imageSize)
                        .foregroundColor(.blue)
                        .offset(x: CGFloat(index) * FriendsListViewConstants.imageOffset)
                }
            }
            .padding()

            if friendsCount > 1 {
                Text(String(format: FriendsListViewConstants.friendsCountTextMultiple, friendsCount))
                    .foregroundStyle(.white)
                    .padding()
            } else if friendsCount == 1 {
                Text(String(format: FriendsListViewConstants.friendsCountTextSingle, friendsCount))
                    .foregroundStyle(.white)
                    .padding()
            } else {
                Text(FriendsListViewConstants.noFriendsText)
                    .foregroundStyle(.white)
                    .padding()
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
        .fixedSize(horizontal: false, vertical: true)
        .background(Color(ColorsEnum.baseGrey))
        .cornerRadius(FriendsListViewConstants.cornerRadius)
    }
}

#Preview {
    FriendsListView()
}
