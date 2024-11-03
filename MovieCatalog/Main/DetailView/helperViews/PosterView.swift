//
//  MoviePosterView.swift
//  MovieCatalog
//
//  Created by dark type on 13.10.2024.
//

import SwiftUI

struct PosterView: View {
    var posterImage: Image

    var body: some View {
        posterImage
            .resizable()
            .scaledToFit()
            .frame(maxWidth: UIScreen.main.bounds.width)
            .clipped()
            .clipShape(BottomRoundedRectangle(cornerRadius: 32))
            .edgesIgnoringSafeArea(.top)
    }
}

#Preview {
    PosterView(posterImage: Image("Poster2"))
}

struct BottomRoundedRectangle: Shape {
    var cornerRadius: CGFloat

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: [.bottomLeft, .bottomRight],
            cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
        )
        return Path(path.cgPath)
    }
}
