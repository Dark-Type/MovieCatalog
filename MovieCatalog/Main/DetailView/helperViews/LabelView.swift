//
//  MovieLabelView.swift
//  MovieCatalog
//
//  Created by dark type on 13.10.2024.
//

import SwiftUI

struct LabelView: View {
    let mainText: String
    let descriptionText: String
   

    var body: some View {
        ZStack {
            ColorsEnum.orangeLinearGradient
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(mainText)
                        .font(.headline)
                        .foregroundColor(.white)
                    Text(descriptionText)
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
                .padding()
                Spacer()
            }
        }
       
        .cornerRadius(10)
        .fixedSize(horizontal: false, vertical: true)
        .frame(maxWidth: .infinity)
    }
}
struct LabelViewPreview: PreviewProvider {
    static var previews: some View {
            LabelView(mainText: "Main Text", descriptionText: "Description Text")
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
