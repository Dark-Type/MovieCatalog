//
//  MovieReviewsView.swift
//  MovieCatalog
//
//  Created by dark type on 13.10.2024.
//

import SwiftUI

enum ReviewsViewConstants {
    static let title = "Отзывы"
    static let addReviewButtonText = "Добавить отзыв"
    static let chevronLeftImage = "ChevronLeft"
    static let chevronRightImage = "ChevronRight"
    static let reviewsImage = "Reviews"
    static let favoriteStarImage = "FavoriteStar"
    static let personCircleImage = "person.circle"
    static let padding: CGFloat = 10
    static let cornerRadius: CGFloat = 10
    static let buttonCornerRadius: CGFloat = 8
    static let avatarSize: CGFloat = 50
    static let spacing: CGFloat = 10
}

struct ReviewsView: View {
    let reviews: [Review]
    @Binding var showAddReview: Bool
    @State private var selectedIndex = 0

    var body: some View {
        VStack {
            HStack {
                Image(ReviewsViewConstants.reviewsImage)
                    .renderingMode(.template)
                    .frame(alignment: .leading)

                Text(ReviewsViewConstants.title)
                Spacer()
            }
            .foregroundStyle(Color(ColorsEnum.subTitleGrey))
            .padding(.horizontal)

            TabView(selection: $selectedIndex) {
                ForEach(reviews.indices, id: \.self) { index in
                    ReviewItemView(review: reviews[index])
                        .padding()
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .scaledToFit()
            .disabled(true)

            HStack {
                Button(action: {
                    showAddReview = true
                }) {
                    Text(ReviewsViewConstants.addReviewButtonText)
                        .padding()
                        .background(AnyView(ColorsEnum.orangeLinearGradient))
                        .cornerRadius(ReviewsViewConstants.buttonCornerRadius)
                        .foregroundStyle(.white)
                }

                HStack(spacing: ReviewsViewConstants.spacing) {
                    Button(action: {
                        if selectedIndex > 0 {
                            selectedIndex -= 1
                        }
                    }) {
                        Image(ReviewsViewConstants.chevronLeftImage)
                            .renderingMode(.template)
                            .padding()
                            .foregroundStyle(selectedIndex > 0 ? Color(.white) : Color(ColorsEnum.subTitleGrey))
                            .background(selectedIndex > 0 ? Color(ColorsEnum.baseDarkGrey) : Color(ColorsEnum.baseGrey))
                            .cornerRadius(ReviewsViewConstants.buttonCornerRadius)
                    }
                    .disabled(selectedIndex == 0)

                    Button(action: {
                        if selectedIndex < reviews.count - 1 {
                            selectedIndex += 1
                        }
                    }) {
                        Image(ReviewsViewConstants.chevronRightImage)
                            .renderingMode(.template)
                            .padding()
                            .foregroundStyle(selectedIndex < reviews.count - 1 ? Color(.white) : Color(ColorsEnum.subTitleGrey))
                            .background(selectedIndex < reviews.count - 1 ? Color(ColorsEnum.baseDarkGrey) : Color(ColorsEnum.baseGrey))
                            .cornerRadius(ReviewsViewConstants.buttonCornerRadius)
                    }
                    .disabled(selectedIndex == reviews.count - 1)
                }
            }
        }
        .padding()
        .background(Color(ColorsEnum.baseGrey))
        .cornerRadius(ReviewsViewConstants.cornerRadius)
    }
}

struct ReviewItemView: View {
    let review: Review

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if let avatar = review.author.avatar {
                    Image(uiImage: avatar)
                        .resizable()
                        .scaledToFit()
                        .frame(width: ReviewsViewConstants.avatarSize, height: ReviewsViewConstants.avatarSize)
                        .clipShape(Circle())
                } else {
                    Image(systemName: ReviewsViewConstants.personCircleImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: ReviewsViewConstants.avatarSize, height: ReviewsViewConstants.avatarSize)
                        .clipShape(Circle())
                }

                VStack(alignment: .leading) {
                    Text(review.author.name)
                        .foregroundStyle(.white)
                        .font(.headline)
                    Text(review.createDateTime)
                        .foregroundStyle(.white)
                        .font(.subheadline)
                }
                Spacer()
                HStack {
                    Image(ReviewsViewConstants.favoriteStarImage)
                        .renderingMode(.template)
                        .foregroundStyle(.white)
                    Text("\(review.rating)")
                        .foregroundStyle(.white)
                        .font(.headline)
                        .padding(5)
                        .background(Color(ColorsEnum.baseGrey))
                        .cornerRadius(ReviewsViewConstants.buttonCornerRadius)
                }
            }
            .padding(.bottom, 5)

            Text(review.reviewText)
                .foregroundStyle(.white)
                .padding(.top, 5)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding()
        .background(Color(ColorsEnum.baseDarkGrey))
        .cornerRadius(ReviewsViewConstants.buttonCornerRadius)
    }
}
