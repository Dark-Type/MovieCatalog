//
//  RatingSubView.swift
//  MovieCatalog
//
//  Created by dark type on 19.10.2024.
//

import SwiftUI

struct RatingSubView: View {
    var image: Image
    var rating: Double
    
    var body: some View {
        HStack {
            image
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .padding(.trailing, 10)
            Text(String(format: "%.1f", rating))
                .foregroundStyle(.white)
                .fixedSize(horizontal: true, vertical: false)
        }
        .padding()
        .background(Color(ColorsEnum.baseDarkGrey))
        .cornerRadius(8)
    }
}

#Preview {
    RatingSubView(image: Image(uiImage: UIImage(named: "Poster1")!), rating: 10.5)
}
