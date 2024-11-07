//
//  FIrstDetailView.swift
//  MovieCatalog
//
//  Created by dark type on 11.10.2024.
//

import SwiftUI

enum MovieDetailViewConstants {
    static let chevronLeftImage = "ChevronLeft"
    static let padding: CGFloat = 20
    static let buttonSize: CGFloat = 40
    static let buttonCornerRadius: CGFloat = 8
    static let overlayOpacity: CGFloat = 0.4
    static let popupWidthMultiplier: CGFloat = 0.9
    static let popupHeightMultiplier: CGFloat = 0.7
    static let popupCornerRadius: CGFloat = 10
    static let popupShadowRadius: CGFloat = 10
}

struct MovieDetailView: View {
    @StateObject private var viewModel: MovieDetailViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showAddReview = false
    @State private var isEditingReview = false
    @State private var reviewToEdit: Review?

    init(movie: Movie) {
        _viewModel = StateObject(wrappedValue: MovieDetailViewModel(movie: movie))
    }

    var body: some View {
        ZStack(alignment: .top) {
            let posterImage = viewModel.movie.poster
            PosterView(posterImage: Image(uiImage: posterImage))
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)

            VStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(MovieDetailViewConstants.chevronLeftImage)
                            .renderingMode(.template)
                            .tint(.white)
                            .padding()
                            .background(Color(ColorsEnum.baseGrey))
                            .frame(width: MovieDetailViewConstants.buttonSize, height: MovieDetailViewConstants.buttonSize)
                            .cornerRadius(MovieDetailViewConstants.buttonCornerRadius)
                    }
                    Spacer()
                    favoriteButton
                }
                .padding()
                .background(Color.clear)

                ScrollView {
                    VStack(spacing: MovieDetailViewConstants.padding) {
                        Spacer().frame(height: 350)

                        LabelView(mainText: viewModel.movie.name, descriptionText: viewModel.movie.tagline)
                            .padding(.horizontal, 5)

                        FriendsListView(viewModel: viewModel)
                            .padding(.horizontal, 5)

                        DescriptionView(description: viewModel.movie.description)
                            .padding(.horizontal, 5)

                        RatingView(ratings: viewModel.movie.ratings)
                            .padding(.horizontal, 5)

                        InfoView(
                            title: viewModel.movie.name,
                            releaseDate: String(viewModel.movie.year),
                            country: viewModel.movie.country,
                            timeDuration: viewModel.movie.time,
                            ageRestriction: viewModel.movie.ageLimit
                        )
                        .padding(.horizontal, 5)

                        DirectorView(authors: viewModel.movie.directors)
                            .padding(.horizontal, 5)

                        GenresView(viewModel: viewModel, genres: viewModel.movie.genres)
                            .padding(.horizontal, 5)

                        RevenueView(revenues: [
                            Revenue(title: "Бюджет", description: "$\(viewModel.movie.budget)"),
                            Revenue(title: "Сборы в мире", description: "$\(viewModel.movie.fees)")

                        ])
                        .padding(.horizontal, 5)

                        ReviewsView(reviews: viewModel.reviews, showAddReview: $showAddReview, viewModel: viewModel, onEdit: { review in
                            reviewToEdit = review
                            isEditingReview = true
                        })
                        .padding(.horizontal)
                    }
                    .padding(.horizontal, 5)
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }

            if showAddReview || isEditingReview {
                GeometryReader { geometry in
                    Color.black.opacity(0.5)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            showAddReview = false
                            isEditingReview = false
                        }

                    AddReviewView(
                        review: reviewToEdit,
                        viewModel: viewModel,
                        showPopup: showAddReview ? $showAddReview : $isEditingReview
                    )
                    .frame(
                        width: UIScreen.main.bounds.width * MovieDetailViewConstants.popupWidthMultiplier,
                        height: UIScreen.main.bounds.height * MovieDetailViewConstants.popupHeightMultiplier
                    )
                    .background(Color(ColorsEnum.baseDarkGrey))
                    .cornerRadius(MovieDetailViewConstants.popupCornerRadius)
                    .shadow(radius: MovieDetailViewConstants.popupShadowRadius)
                    .transition(.move(edge: .bottom))
                    .zIndex(1)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                }
            }

            if viewModel.isLoading {
                ProgressView("Loading...")
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(2)
                    .background(Color.black.opacity(0.5).edgesIgnoringSafeArea(.all))
            }

            if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
                    .onTapGesture {
                        viewModel.errorMessage = nil
                    }
            }
        }
        .background(Color(ColorsEnum.baseDarkGrey))
        .onAppear {
            viewModel.loadFriendsWithHighReviews()
        }
    }

    private var favoriteButton: some View {
        Button(action: {
            viewModel.toggleFavoriteStatus()
        }) {
            Image(viewModel.isFavorite ? "FilledHeart" : "EmptyHeart")
                .renderingMode(.template)
                .tint(.white)
                .padding()
                .background(viewModel.isFavorite ? AnyView(ColorsEnum.orangeLinearGradient) : AnyView(Color(ColorsEnum.baseGrey)))
                .frame(width: MovieDetailViewConstants.buttonSize, height: MovieDetailViewConstants.buttonSize)
                .cornerRadius(MovieDetailViewConstants.buttonCornerRadius)
        }
    }}
