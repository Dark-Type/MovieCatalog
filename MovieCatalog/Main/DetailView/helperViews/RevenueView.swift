//
//  MovieRevenueView.swift
//  MovieCatalog
//
//  Created by dark type on 13.10.2024.
//

import SwiftUI

enum RevenueViewConstants {
    static let title = "Финансы"
    static let imageName = "Money"
    static let spacing: CGFloat = 10
    static let padding: CGFloat = 16
    static let cornerRadius: CGFloat = 16
    static let itemCornerRadius: CGFloat = 8
    static let minColumnWidth: CGFloat = 100
}

struct RevenueView: View {
    let revenues: [Revenue]

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(RevenueViewConstants.imageName)
                    .renderingMode(.template)
                    .frame(alignment: .center)

                Text(RevenueViewConstants.title)
                Spacer()
            }
            .foregroundStyle(Color(ColorsEnum.subTitleGrey))

            LazyVGrid(columns: [GridItem(.adaptive(minimum: RevenueViewConstants.minColumnWidth))], spacing: RevenueViewConstants.spacing) {
                ForEach(revenues) { revenue in
                    VStack(alignment: .leading) {
                        Text(revenue.title)
                            .font(.headline)
                            .foregroundStyle(Color(ColorsEnum.subTitleGrey))
                        Text(revenue.description)
                            .font(.subheadline)
                            .foregroundStyle(.white)
                    }
                    .padding()
                    .background(Color(ColorsEnum.baseDarkGrey))
                    .cornerRadius(RevenueViewConstants.itemCornerRadius)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(RevenueViewConstants.padding)
        .background(Color(ColorsEnum.baseGrey))
        .cornerRadius(RevenueViewConstants.cornerRadius)
    }
}

#Preview {
    RevenueView(revenues: [
        Revenue(title: "budget", description: "$ 100"),
        Revenue(title: "revenue in america", description: "$ 0.5"),
        Revenue(title: "revenue in russia", description: "пачка чипсов")
    ])
}

