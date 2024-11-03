//
//  DescriptionView.swift
//  MovieCatalog
//
//  Created by dark type on 18.10.2024.
//

import SwiftUI

struct DescriptionView: View {
    var description:String
    
    var body: some View {
        
        Text(description)
            .frame(maxWidth: .infinity)
            .foregroundStyle(.white)
            .padding()
            .fixedSize(horizontal: false, vertical: true)
            .background(Color(ColorsEnum.baseGrey))
            .cornerRadius(16)
            
    }
}

#Preview {
    DescriptionView(description: "Hello, World!")
}
