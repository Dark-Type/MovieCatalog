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
                }
                .padding()
                .background(Color.clear)

                ScrollView {
                    VStack(spacing: MovieDetailViewConstants.padding) {
                        Spacer().frame(height: 200)

                        LabelView(mainText: viewModel.movie.name, descriptionText: viewModel.movie.tagline)
                            .padding(.horizontal)

                        FriendsListView(friendsCount: 1, images: [Image(uiImage: viewModel.movie.poster)])
                            .padding(.horizontal)

                        DescriptionView(description: viewModel.movie.description)
                            .padding(.horizontal)

                        RatingView(ratings: viewModel.movie.ratings)
                            .padding(.horizontal)

                        InfoView(
                            title: viewModel.movie.name,
                            releaseDate: String(viewModel.movie.year),
                            country: viewModel.movie.country,
                            timeDuration: viewModel.movie.time,
                            ageRestriction: viewModel.movie.ageLimit
                        )
                        .padding(.horizontal)

                        DirectorView(authors: viewModel.movie.directors)
                            .padding(.horizontal)

                        GenresView(genres: viewModel.movie.genres)
                            .padding(.horizontal)

                        RevenueView(revenues: [
                            Revenue(title: "Box Office", description: "$\(viewModel.movie.fees)"),
                            Revenue(title: "Budget", description: "$\(viewModel.movie.budget)")
                        ])
                        .padding(.horizontal)

                        ReviewsView(reviews: viewModel.movie.reviews, showAddReview: $showAddReview)
                            .padding(.horizontal)
                    }
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }

            if showAddReview {
                Color.black.opacity(MovieDetailViewConstants.overlayOpacity)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        showAddReview = false
                    }

                AddReviewView(showPopup: $showAddReview)
                    .frame(
                        width: UIScreen.main.bounds.width * MovieDetailViewConstants.popupWidthMultiplier,
                        height: UIScreen.main.bounds.height * MovieDetailViewConstants.popupHeightMultiplier
                    )
                    .background(Color(ColorsEnum.baseDarkGrey))
                    .cornerRadius(MovieDetailViewConstants.popupCornerRadius)
                    .shadow(radius: MovieDetailViewConstants.popupShadowRadius)
                    .transition(.move(edge: .bottom))
                    .zIndex(1)
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
            UINavigationBar.appearance().isHidden = true
        }
        .onDisappear {
            UINavigationBar.appearance().isHidden = false
        }
    }
}

