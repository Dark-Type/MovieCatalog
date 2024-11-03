//
//  MCToggleSwitch.swift
//  MovieCatalog
//
//  Created by dark type on 13.10.2024.
//

import UIKit
enum MCToggleViewResources {
    static let leftButtonTitle = "Мужчина"
    static let rightButtonTitle = "Женщина"
    static let buttonCornerRadius: CGFloat = 8
}

protocol MCToggleViewDelegate: AnyObject {
    func toggleViewDidChange(_ toggleView: MCToggleView, isLeftButtonOn: Bool)
}

class MCToggleView: UIView {
    weak var delegate: MCToggleViewDelegate?

    private let leftButton = UIButton()
    private let rightButton = UIButton()
    private var isLeftButtonOn = true

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
        setupConstraints()
        setupGestureRecognizers()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
        setupConstraints()
        setupGestureRecognizers()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateButtonStates()
    }

    func getIsLeftButtonOn() -> Bool {
        return isLeftButtonOn
    }

    func setIsLeftButtonOn(_ isLeftButtonOn: Bool) {
        self.isLeftButtonOn = isLeftButtonOn
        updateButtonStates()
    }

    @objc private func toggleLeftButton() {
        isLeftButtonOn = true
        updateButtonStates()
        delegate?.toggleViewDidChange(self, isLeftButtonOn: isLeftButtonOn)
    }

    @objc private func toggleRightButton() {
        isLeftButtonOn = false
        updateButtonStates()
        delegate?.toggleViewDidChange(self, isLeftButtonOn: isLeftButtonOn)
    }

    private func updateButtonStates() {
        if isLeftButtonOn {
            applyGradient(to: leftButton)
            rightButton.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
            rightButton.backgroundColor = ColorsEnum.baseGrey
        } else {
            applyGradient(to: rightButton)
            leftButton.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
            leftButton.backgroundColor = ColorsEnum.baseGrey
        }
    }

    private func setupButtons() {
        leftButton.setTitle(MCToggleViewResources.leftButtonTitle, for: .normal)
        leftButton.setTitleColor(.white, for: .normal)
        leftButton.layer.cornerRadius = MCToggleViewResources.buttonCornerRadius
        leftButton.clipsToBounds = true
        addSubview(leftButton)

        rightButton.setTitle(MCToggleViewResources.rightButtonTitle, for: .normal)
        rightButton.setTitleColor(.white, for: .normal)
        rightButton.layer.cornerRadius = MCToggleViewResources.buttonCornerRadius
        rightButton.clipsToBounds = true
        addSubview(rightButton)
    }

    private func setupConstraints() {
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        rightButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            leftButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            leftButton.topAnchor.constraint(equalTo: topAnchor),
            leftButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            leftButton.trailingAnchor.constraint(equalTo: rightButton.leadingAnchor),

            rightButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            rightButton.topAnchor.constraint(equalTo: topAnchor),
            rightButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            rightButton.widthAnchor.constraint(equalTo: leftButton.widthAnchor)
        ])
    }

    private func applyGradient(to button: UIButton) {
        let gradientLayer = ColorsEnum.orangeGradient
        gradientLayer.frame = button.bounds
        button.layer.insertSublayer(gradientLayer, at: 0)
    }

    private func setupGestureRecognizers() {
        leftButton.addTarget(self, action: #selector(toggleLeftButton), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(toggleRightButton), for: .touchUpInside)
    }
}
