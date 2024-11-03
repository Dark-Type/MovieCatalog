//
//  MovieInfoView.swift
//  MovieCatalog
//
//  Created by dark type on 13.10.2024.
//

import SwiftUI

enum InfoViewConstants {
    static let title = "Информация"
    static let countryLabelSingle = "Страна"
    static let countryLabelMultiple = "Страны"
    static let ageLabel = "Возраст"
    static let timeLabel = "Время"
    static let releaseDateLabel = "Год выхода"
    static let imageName = "Info"
    static let spacing: CGFloat = 10
    static let gridSpacing: CGFloat = 20
    static let padding: CGFloat = 20
    static let cornerRadius: CGFloat = 10
    static let itemCornerRadius: CGFloat = 8
    static let columns = [
        GridItem(.flexible(), spacing: gridSpacing),
        GridItem(.flexible(), spacing: gridSpacing)
    ]
}

struct InfoView: View {
    var title: String
    var releaseDate: String
    var country: String
    var timeDuration: String
    var ageRestriction: String

    var body: some View {
        VStack(alignment: .leading, spacing: InfoViewConstants.spacing) {
            HStack {
                Image(InfoViewConstants.imageName)
                    .renderingMode(.template)
                Text(InfoViewConstants.title)
            }
            .foregroundStyle(.white)

            LazyVGrid(columns: InfoViewConstants.columns, spacing: InfoViewConstants.gridSpacing) {
                InfoItemView(label: (country.contains(",") ? InfoViewConstants.countryLabelMultiple : InfoViewConstants.countryLabelSingle), value: country)
                
                InfoItemView(label: InfoViewConstants.ageLabel, value: ageRestriction)
                
                InfoItemView(label: InfoViewConstants.timeLabel, value: timeDuration)
                
                InfoItemView(label: InfoViewConstants.releaseDateLabel, value: releaseDate)
            }
            .padding(.horizontal, InfoViewConstants.padding)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(ColorsEnum.baseGrey))
        .cornerRadius(InfoViewConstants.cornerRadius)
    }
}

struct InfoItemView: View {
    var label: String
    var value: String

    var body: some View {
        VStack {
            Text("\(label)")
                .foregroundStyle(.subTitleGrey)
                .fixedSize(horizontal: true, vertical: false)
            Text(value)
                .font(.subheadline)
                .fixedSize(horizontal: true, vertical: false)
        }
        .frame(maxWidth: .infinity)
        .foregroundStyle(.white)
        .padding()
        .background(Color(ColorsEnum.baseDarkGrey))
        .cornerRadius(InfoViewConstants.itemCornerRadius)
    }
}

#Preview {
    InfoView(
        title: "Edging Runner",
        releaseDate: "2022",
        country: "USA",
        timeDuration: "2 ч 30 мин",
        ageRestriction: "PG-13"
    )
}
