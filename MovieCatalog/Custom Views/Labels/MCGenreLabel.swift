//
//  MCGenreView.swift
//  MovieCatalog
//
//  Created by dark type on 17.10.2024.
//

import UIKit

class MCGenreLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    convenience init(title: String, isActive: Bool) {
        self.init()
        self.text = title
        layer.cornerRadius = 10
        clipsToBounds = true
        isActive ? addOrangeGradient() : setupSolidColorBackground(color: .gray)
    }

    private func commonInit() {
        layer.masksToBounds = true
    }

   
    func addOrangeGradient() {
        deleteOrangeGradient()
        let gradientLayer = ColorsEnum.orangeGradient
        gradientLayer().frame = bounds
        layer.insertSublayer(gradientLayer(), at: 0)
    }

    func deleteOrangeGradient() {
        layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
    }

    private func setupSolidColorBackground(color: UIColor) {
        deleteOrangeGradient()
        backgroundColor = color
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateGradientFrame()
    }

    private func updateGradientFrame() {
        guard let gradientLayer = layer.sublayers?.first as? CAGradientLayer else { return }
        gradientLayer.frame = bounds
    }
}
