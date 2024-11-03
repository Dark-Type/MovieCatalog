//
//  GradientTextLabel.swift
//  MovieCatalog
//
//  Created by dark type on 18.10.2024.
//

import UIKit

class GradientTextLabel: UILabel {
    private let gradientLayer = ColorsEnum.orangeGradient
    private let textLayer = CATextLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayers()
    }

    private func setupLayers() {
        layer.addSublayer(gradientLayer)

        textLayer.alignmentMode = .center
        textLayer.contentsScale = UIScreen.main.scale
        gradientLayer.mask = textLayer
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        updateTextLayer()
    }

    override var text: String? {
        didSet {
            updateTextLayer()
        }
    }

    override var font: UIFont! {
        didSet {
            updateTextLayer()
        }
    }

    private func updateTextLayer() {
        guard let text = text else { return }
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font as Any
        ]
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        textLayer.string = attributedString
        textLayer.frame = bounds
    }
}
