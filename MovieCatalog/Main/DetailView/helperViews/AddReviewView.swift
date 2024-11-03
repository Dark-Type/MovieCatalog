//
//  MovieAddReviewView.swift
//  MovieCatalog
//
//  Created by dark type on 13.10.2024.
//

import SwiftUI

enum AddReviewViewConstants {
    static let titleFont: Font = .title
    static let subheadlineFont: Font = .subheadline
    static let padding: CGFloat = 8
    static let cornerRadius: CGFloat = 8
    static let shadowRadius: CGFloat = 10
    static let frameWidthMultiplier: CGFloat = 0.9
    static let frameHeightMultiplier: CGFloat = 0.7
    static let buttonPadding: CGFloat = 4
    static let buttonCornerRadius: CGFloat = 8
    static let toggleWidth: CGFloat = 52
    static let toggleHeight: CGFloat = 32
    static let toggleCornerRadius: CGFloat = 15
    static let circleWidth: CGFloat = 24
    static let circleHeight: CGFloat = 24
    static let circleOffset: CGFloat = 10
    static let sliderHeight: CGFloat = 4
    static let sliderCircleWidth: CGFloat = 20
    static let sliderCircleHeight: CGFloat = 20
    static let sliderFrameHeight: CGFloat = 20

    static let addReviewTitle = "Добавить отзыв"
    static let ratingText = "Оценка"
    static let commentPlaceholder = "Текст отзыва"
    static let anonymousReviewToggle = "Анонимный отзыв"
    static let sendButtonTitle = "Отправить"
}

struct AddReviewView: View {
    @Binding var showPopup: Bool
    @State private var rating: Double = 0.0
    @State private var comment: String = ""
    @State private var isAnonymous: Bool = false

    var body: some View {
        ZStack {
            if showPopup {
                Color(ColorsEnum.baseDarkGrey)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        showPopup = false
                    }

                VStack {
                    HStack {
                        Text(AddReviewViewConstants.addReviewTitle)
                            .font(AddReviewViewConstants.titleFont)
                            .foregroundStyle(Color(ColorsEnum.subTitleGrey))
                        Spacer()
                    }

                    HStack {
                        Text(AddReviewViewConstants.ratingText)
                            .font(AddReviewViewConstants.subheadlineFont)
                            .foregroundStyle(Color(ColorsEnum.subTitleGrey))
                        Spacer()
                    }

                    GradientSlider(value: $rating, range: 0 ... 10, step: 1, gradient: ColorsEnum.orangeLinearGradient)

                    ZStack(alignment: .topLeading) {
                        if comment.isEmpty {
                            Text(AddReviewViewConstants.commentPlaceholder)
                                .foregroundColor(Color(ColorsEnum.subTitleGrey))
                                .padding(.horizontal, AddReviewViewConstants.padding)
                                .padding(.vertical, AddReviewViewConstants.padding)
                        }
                        TextEditor(text: $comment)
                            .background(Color(ColorsEnum.greyFaded))
                            .padding(AddReviewViewConstants.buttonPadding)
                            .background(Color(ColorsEnum.baseGrey))
                            .cornerRadius(AddReviewViewConstants.cornerRadius)
                            .foregroundStyle(Color(ColorsEnum.greyFaded))

                    }
                    .background(Color(ColorsEnum.baseGrey))
                    .cornerRadius(AddReviewViewConstants.cornerRadius)

                    Toggle(AddReviewViewConstants.anonymousReviewToggle, isOn: $isAnonymous)
                        .toggleStyle(GradientToggleStyle())
                        .foregroundStyle(Color(ColorsEnum.subTitleGrey))

                    HStack {
                        Spacer()
                        Button(AddReviewViewConstants.sendButtonTitle) {
                            showPopup = false
                        }
                        .padding()
                        .background(AnyView(ColorsEnum.orangeLinearGradient))
                        .cornerRadius(AddReviewViewConstants.buttonCornerRadius)
                        .foregroundStyle(.white)
                    }
                    .padding()
                }
                .padding()
                .background(Color(ColorsEnum.baseDarkGrey))
                .cornerRadius(AddReviewViewConstants.cornerRadius)
                .frame(width: UIScreen.main.bounds.width * AddReviewViewConstants.frameWidthMultiplier, height: UIScreen.main.bounds.height * AddReviewViewConstants.frameHeightMultiplier)
                .shadow(radius: AddReviewViewConstants.shadowRadius)
            }
        }
    }
}

struct GradientToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            ZStack {
                if configuration.isOn {
                    ColorsEnum.orangeLinearGradient
                } else {
                    Color(ColorsEnum.greyFaded)
                }
            }
            .frame(width: AddReviewViewConstants.toggleWidth, height: AddReviewViewConstants.toggleHeight)
            .cornerRadius(AddReviewViewConstants.toggleCornerRadius)
            .overlay(
                Circle()
                    .fill(Color.white)
                    .frame(width: AddReviewViewConstants.circleWidth, height: AddReviewViewConstants.circleHeight)
                    .offset(x: configuration.isOn ? AddReviewViewConstants.circleOffset : -AddReviewViewConstants.circleOffset)
                    .animation(.easeInOut(duration: 0.2), value: configuration.isOn)
            )
            .onTapGesture {
                configuration.isOn.toggle()
            }
        }
    }
}

struct GradientSlider: View {
    @Binding var value: Double
    var range: ClosedRange<Double>
    var step: Double
    var gradient: LinearGradient

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: AddReviewViewConstants.cornerRadius)
                    .fill(Color(ColorsEnum.greyFaded))
                    .frame(height: AddReviewViewConstants.sliderHeight)
                RoundedRectangle(cornerRadius: AddReviewViewConstants.cornerRadius)
                    .fill(gradient)
                    .frame(width: CGFloat((value - range.lowerBound) / (range.upperBound - range.lowerBound)) * geometry.size.width, height: AddReviewViewConstants.sliderHeight)
                Circle()
                    .fill(Color.white)
                    .frame(width: AddReviewViewConstants.sliderCircleWidth, height: AddReviewViewConstants.sliderCircleHeight)
                    .offset(x: CGFloat((value - range.lowerBound) / (range.upperBound - range.lowerBound)) * geometry.size.width - AddReviewViewConstants.sliderCircleWidth / 2)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { gesture in
                                let newValue = min(max(0, gesture.location.x / geometry.size.width), 1) * (range.upperBound - range.lowerBound) + range.lowerBound
                                value = round(newValue / step) * step
                            }
                    )
            }
        }
        .frame(height: AddReviewViewConstants.sliderFrameHeight)
    }
}
