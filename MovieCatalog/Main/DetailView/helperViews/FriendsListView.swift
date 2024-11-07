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
    @ObservedObject var viewModel: MovieDetailViewModel

    var body: some View {
        VStack {
            if viewModel.friends.isEmpty {
                Text(FriendsListViewConstants.noFriendsText)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .padding(.horizontal)
                    .fixedSize(horizontal: false, vertical: true)
                    .background(Color(ColorsEnum.baseGrey))
                    .cornerRadius(FriendsListViewConstants.cornerRadius)
                    
            } else {
                HStack(spacing: FriendsListViewConstants.spacing) {
                    ZStack {
                        ForEach(Array(viewModel.friends.enumerated()), id: \.offset) { index, friend in
                            if let avatar = friend.avatar {
                                Image(uiImage: avatar)
                                    .resizable()
                                    .clipShape(Circle())
                                    .frame(width: FriendsListViewConstants.imageSize, height: FriendsListViewConstants.imageSize)
                                    .offset(x: CGFloat(index) * FriendsListViewConstants.imageOffset)
                            } else {
                                Circle()
                                    .fill(Color.gray)
                                    .frame(width: FriendsListViewConstants.imageSize, height: FriendsListViewConstants.imageSize)
                                    .offset(x: CGFloat(index) * FriendsListViewConstants.imageOffset)
                            }
                        }
                    }
                    .padding()

                    Text(String(format: viewModel.friendsWithHighReviewsCount > 1 ? FriendsListViewConstants.friendsCountTextMultiple : FriendsListViewConstants.friendsCountTextSingle, viewModel.friendsWithHighReviewsCount))
                        .foregroundStyle(.white)
                        .padding()
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
                .fixedSize(horizontal: false, vertical: true)
                .background(Color(ColorsEnum.baseGrey))
                .cornerRadius(FriendsListViewConstants.cornerRadius)
            }
        }
        .onAppear {
            viewModel.loadFriendsWithHighReviews()
        }
    }
}
