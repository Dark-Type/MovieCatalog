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
    @ObservedObject var viewModel: MovieDetailViewModel
    var onEdit: (Review) -> Void

    @State private var selectedIndex = 0
    @State private var showingFriendAddedAlert = false
    @State private var friendAddedMessage = ""

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
                    ReviewItemView(
                        review: reviews[index],
                        onEdit: { review in
                            onEdit(review)
                        },
                        onDelete: { review in
                            viewModel.deleteReview(review: review) { success in
                                if success {
                                } else {}
                            }
                        },
                        onAddFriend: { authorDetails in
                            addFriend(authorDetails)
                        }
                    )
                    .padding()
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .scaledToFit()

            HStack {
                if let userReview = reviews.first(where: { $0.isUserReview }) {
                    Button(action: {
                        onEdit(userReview)
                    }) {
                        Text("Изменить отзыв")
                            .padding()
                            .background(ColorsEnum.orangeLinearGradient)
                            .cornerRadius(ReviewsViewConstants.buttonCornerRadius)
                            .foregroundColor(.white)
                    }

                    Button(action: {
                        viewModel.deleteReview(review: userReview) { success in
                            if success {
                            } else {}
                        }
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color(ColorsEnum.baseDarkGrey))
                            .frame(width: 40, height: 40)
                            .cornerRadius(ReviewsViewConstants.buttonCornerRadius)
                    }
                } else {
                    Button(action: {
                        showAddReview = true
                    }) {
                        Text(ReviewsViewConstants.addReviewButtonText)
                            .padding()
                            .background(ColorsEnum.orangeLinearGradient)
                            .cornerRadius(ReviewsViewConstants.buttonCornerRadius)
                            .foregroundColor(.white)
                    }
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
                            .frame(width: 40, height: 40)
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
                            .frame(width: 40, height: 40)
                            .cornerRadius(ReviewsViewConstants.buttonCornerRadius)
                    }
                    .disabled(selectedIndex == reviews.count - 1)
                }
            }
        }
        .padding()
        .background(Color(ColorsEnum.baseGrey))
        .cornerRadius(ReviewsViewConstants.cornerRadius)
        .alert(isPresented: $showingFriendAddedAlert) {
            Alert(title: Text("Friend Added"), message: Text(friendAddedMessage), dismissButton: .default(Text("OK")))
        }
    }

    private func addFriend(_ authorDetails: AuthorDetails) {
        guard let userLogin = viewModel.currentUserProfile?.nickName else {
            print("Error: userLogin is nil")
            return
        }
        viewModel.friendsWithHighReviewsCount += 1
        FriendsService.shared.addFriend(authorDetails)
        friendAddedMessage = "\(authorDetails.nickName ?? "This author") был добавлен Вам в друзья."
        showingFriendAddedAlert = true
        print("Friend added: \(authorDetails.nickName ?? "Unknown") for userLogin: \(userLogin)")
        viewModel.loadFriendsWithHighReviews()
    }
}

struct ReviewItemView: View {
    let review: Review
    let onEdit: (Review) -> Void
    let onDelete: (Review) -> Void
    let onAddFriend: (AuthorDetails) -> Void

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if let avatar = review.author.avatar {
                    Image(uiImage: avatar)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .onTapGesture {
                            if let authorDetails = review.author.toAuthorDetails() {
                                onAddFriend(authorDetails)
                            }
                        }
                } else {
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 50, height: 50)
                        .onTapGesture {
                            if let authorDetails = review.author.toAuthorDetails() {
                                onAddFriend(authorDetails)
                            }
                        }
                }

                VStack(alignment: .leading) {
                    Text(review.author.name)
                        .font(.headline)
                    Text(review.createDateTime)
                        .font(.subheadline)
                        .foregroundColor(.gray)
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

extension Author {
    func toAuthorDetails() -> AuthorDetails? {
        guard id != "Anonymous" else { return nil }
        return AuthorDetails(userId: id, nickName: name, avatar: avatarURL)
    }
}
