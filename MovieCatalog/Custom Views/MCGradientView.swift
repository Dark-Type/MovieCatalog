//
//  MCGradientView.swift
//  MovieCatalog
//
//  Created by dark type on 26.10.2024.
//

import UIKit

class MCGradientView: UIView {
    private let gradientLayer = ColorsEnum.orangeGradient

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradientLayer()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradientLayer()
    }

    private func setupGradientLayer() {
        layer.insertSublayer(gradientLayer(), at: 0)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer().frame = bounds
    }
}
