//
//  MCButton.swift
//  MovieCatalog
//
//  Created by dark type on 11.10.2024.
//

import UIKit

enum MCButtonConstants {
    static let defaultBackgroundColor = ColorsEnum.baseGrey
    static let defaultFontColor = ColorsEnum.greyFaded
    static let defaultFontSize: CGFloat = 14
    static let cornerRadius: CGFloat = 10
}

class MCButton: UIButton {
    
    init(title: String? = nil, fontSize: CGFloat = MCButtonConstants.defaultFontSize, isActive: Bool = false, fontColor: UIColor? = MCButtonConstants.defaultFontColor) {
        super.init(frame: .zero)
        setupGradientLayer()

        if let title = title {
            setTitle(title, for: .normal)
        }

        let finalFontColor = isActive ? UIColor.white : fontColor
        setTitleColor(finalFontColor, for: .normal)

        titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        layer.cornerRadius = MCButtonConstants.cornerRadius
        clipsToBounds = true

        if isActive {
            setupOrangeGradient()
        } else {
            setupSolidColorBackground(color: MCButtonConstants.defaultBackgroundColor)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupGradientLayer() {
        layer.masksToBounds = true
    }

    func addOrangeGradient() {
        setupOrangeGradient()
    }

    func deleteOrangeGradient() {
        layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
    }

    private func setupOrangeGradient() {
        let gradientLayer = ColorsEnum.orangeGradient
        layer.insertSublayer(gradientLayer, at: 0)
        updateGradientFrame()
    }

    func setupSolidColorBackground(color: UIColor) {
        layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
        backgroundColor = color
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateGradientFrame()
    }

    private func updateGradientFrame() {
        guard let gradientLayer = layer.sublayers?.first(where: { $0 is CAGradientLayer }) as? CAGradientLayer else { return }
        gradientLayer.frame = bounds
    }
}
