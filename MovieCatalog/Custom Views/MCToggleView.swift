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

    private let leftGradientLayer = CAGradientLayer()
    private let rightGradientLayer = CAGradientLayer()

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
        updateGradientFrames()
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
        UIView.animate(withDuration: 0.3) {
            if self.isLeftButtonOn {
                self.applyGradient(to: self.leftGradientLayer, on: self.leftButton, maskedCorners: [.layerMinXMinYCorner, .layerMinXMaxYCorner])
                self.removeGradient(from: self.rightGradientLayer, on: self.rightButton)
                self.rightButton.backgroundColor = ColorsEnum.baseGrey
            } else {
                self.applyGradient(to: self.rightGradientLayer, on: self.rightButton, maskedCorners: [.layerMaxXMinYCorner, .layerMaxXMaxYCorner])
                self.removeGradient(from: self.leftGradientLayer, on: self.leftButton)
                self.leftButton.backgroundColor = ColorsEnum.baseGrey
            }
        }
    }

    private func setupButtons() {
        leftButton.setTitle(MCToggleViewResources.leftButtonTitle, for: .normal)
        leftButton.setTitleColor(.white, for: .normal)
        leftButton.backgroundColor = ColorsEnum.baseGrey
        leftButton.layer.cornerRadius = MCToggleViewResources.buttonCornerRadius
        leftButton.clipsToBounds = true
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        leftButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        addSubview(leftButton)

        rightButton.setTitle(MCToggleViewResources.rightButtonTitle, for: .normal)
        rightButton.setTitleColor(.white, for: .normal)
        rightButton.backgroundColor = ColorsEnum.baseGrey
        rightButton.layer.cornerRadius = MCToggleViewResources.buttonCornerRadius
        rightButton.clipsToBounds = true
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        rightButton.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        addSubview(rightButton)

        setupGradientLayer(leftGradientLayer, for: leftButton)
        setupGradientLayer(rightGradientLayer, for: rightButton)
    }

    private func setupConstraints() {
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

    private func applyGradient(to gradientLayer: CAGradientLayer, on button: UIButton, maskedCorners: CACornerMask) {
        gradientLayer.removeFromSuperlayer()

        gradientLayer.colors = ColorsEnum.orangeGradient().colors
        gradientLayer.startPoint = ColorsEnum.orangeGradient().startPoint
        gradientLayer.endPoint = ColorsEnum.orangeGradient().endPoint
        gradientLayer.cornerRadius = MCToggleViewResources.buttonCornerRadius
        gradientLayer.masksToBounds = true
        gradientLayer.maskedCorners = maskedCorners

        gradientLayer.frame = button.bounds

        button.layer.insertSublayer(gradientLayer, at: 0)
        button.bringSubviewToFront(button.titleLabel ?? UIView())
    }

    private func removeGradient(from gradientLayer: CAGradientLayer, on button: UIButton) {
        gradientLayer.removeFromSuperlayer()
    }

    private func setupGradientLayer(_ gradientLayer: CAGradientLayer, for button: UIButton) {
        gradientLayer.frame = button.bounds
        gradientLayer.cornerRadius = MCToggleViewResources.buttonCornerRadius
        gradientLayer.masksToBounds = true
    }

    private func setupGestureRecognizers() {
        leftButton.addTarget(self, action: #selector(toggleLeftButton), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(toggleRightButton), for: .touchUpInside)
    }

    private func updateGradientFrames() {
        leftGradientLayer.frame = leftButton.bounds
        rightGradientLayer.frame = rightButton.bounds
    }
}
