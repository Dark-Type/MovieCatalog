//
//  SwipeCardView.swift
//  MovieCatalog
//
//  Created by dark type on 25.10.2024.
//

import UIKit

enum SwipeCardViewConstants {
    static let emptyHeartImageName = "EmptyHeart"
    static let brokenHeartImageName = "BrokenHeart"
    static let heartImageViewSize: CGFloat = 100
    static let maxAlpha: CGFloat = 0.5
    static let rotationAngle: CGFloat = .pi / 8
    static let animationDuration: TimeInterval = 0.3
    static let swipeThreshold: CGFloat = 0.25
}

class SwipeCardView: UIView {
    private let imageView = UIImageView()
    private let heartImageView = UIImageView(image: UIImage(named: SwipeCardViewConstants.emptyHeartImageName)?.withTintColor(.white))
    private let brokenHeartImageView = UIImageView(image: UIImage(named: SwipeCardViewConstants.brokenHeartImageName)?.withTintColor(.white))
    private let overlayView = UIView()
    private var gradientLayer: CAGradientLayer?
    private var originalPoint: CGPoint = .zero

    var onFavorite: (() -> Void)?
    var onHide: (() -> Void)?

    var movie: FeedMovie? {
        didSet {
            if let movie = movie {
                imageView.image = movie.poster
                resetUI()
            }
        }
    }

    var onSwipe: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        addGestureRecognizers()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        addGestureRecognizers()
    }

    private func setupView() {
        layer.cornerRadius = 10
        clipsToBounds = true
        backgroundColor = .white

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)

        heartImageView.alpha = 0
        heartImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(heartImageView)

        brokenHeartImageView.alpha = 0
        brokenHeartImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(brokenHeartImageView)

        overlayView.alpha = 0
        overlayView.layer.cornerRadius = 10
        overlayView.clipsToBounds = true
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(overlayView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),

            heartImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            heartImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            heartImageView.widthAnchor.constraint(equalToConstant: SwipeCardViewConstants.heartImageViewSize),
            heartImageView.heightAnchor.constraint(equalToConstant: SwipeCardViewConstants.heartImageViewSize),

            brokenHeartImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            brokenHeartImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            brokenHeartImageView.widthAnchor.constraint(equalToConstant: SwipeCardViewConstants.heartImageViewSize),
            brokenHeartImageView.heightAnchor.constraint(equalToConstant: SwipeCardViewConstants.heartImageViewSize),

            overlayView.topAnchor.constraint(equalTo: topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func resetUI() {
        heartImageView.alpha = 0
        brokenHeartImageView.alpha = 0
        overlayView.alpha = 0
        gradientLayer?.removeFromSuperlayer()
    }

    private func addGestureRecognizers() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        addGestureRecognizer(panGestureRecognizer)
    }

    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        let distance = abs(translation.x)
        let maxDistance = frame.width / 2
        let alpha = min(distance / maxDistance, SwipeCardViewConstants.maxAlpha)

        switch gesture.state {
        case .began:
            originalPoint = center
        case .changed:
            center = CGPoint(x: originalPoint.x + translation.x, y: originalPoint.y + translation.y)
            let rotationStrength = min(translation.x / frame.width, 1)
            let rotationAngle = SwipeCardViewConstants.rotationAngle * rotationStrength
            transform = CGAffineTransform(rotationAngle: rotationAngle)

            if translation.x > 0 {
                heartImageView.alpha = alpha
                brokenHeartImageView.alpha = 0
                applyGradient()
                overlayView.alpha = alpha
            } else {
                heartImageView.alpha = 0
                brokenHeartImageView.alpha = alpha
                applyGreyOverlay()
                overlayView.alpha = alpha
            }
        case .ended:
            if abs(translation.x) > frame.width * SwipeCardViewConstants.swipeThreshold {
                let direction: CGFloat = translation.x > 0 ? 1 : -1
                animateOffScreen(direction: direction)
                isUserInteractionEnabled = false
                if direction > 0 {
                    onFavorite?()
                } else {
                    onHide?()
                }
            } else {
                resetPosition()
            }
        default:
            break
        }
    }

    private func applyGradient() {
        gradientLayer?.removeFromSuperlayer()

        CATransaction.begin()
        CATransaction.setDisableActions(true)
        let gradient = ColorsEnum.orangeGradient
        gradient.frame = overlayView.bounds
        overlayView.layer.insertSublayer(gradient, at: 0)
        CATransaction.commit()
        gradientLayer = gradient
    }

    private func applyGreyOverlay() {
        gradientLayer?.removeFromSuperlayer()
        overlayView.backgroundColor = ColorsEnum.baseGrey
    }

    private func animateOffScreen(direction: CGFloat) {
        UIView.animate(withDuration: SwipeCardViewConstants.animationDuration, animations: {
            self.center = CGPoint(x: self.originalPoint.x + direction * self.frame.width, y: self.originalPoint.y)
        }) { _ in
            self.removeFromSuperview()
            self.onSwipe?()
            self.isUserInteractionEnabled = true
        }
    }

    private func resetPosition() {
        UIView.animate(withDuration: SwipeCardViewConstants.animationDuration) {
            self.center = self.originalPoint
            self.transform = .identity
            self.heartImageView.alpha = 0
            self.brokenHeartImageView.alpha = 0
            self.overlayView.alpha = 0
            self.gradientLayer?.removeFromSuperlayer()
        }
    }
}
