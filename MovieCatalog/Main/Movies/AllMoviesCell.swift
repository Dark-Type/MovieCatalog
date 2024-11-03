//
//  AllMoviesCell.swift
//  MovieCatalog
//
//  Created by dark type on 27.10.2024.
//

import UIKit

class AllMovieCell: UICollectionViewCell {
    private let imageView = UIImageView()
    private let ratingLabel = UILabel()
    private let ratingBackgroundView = UIView()
    private let favoriteButton = UIButton()
    private let gradientView = MCGradientView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
        setupRatingBackgroundView()
        setupRatingLabel()
        setupGradientView()
        setupFavoriteButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupImageView() {
           imageView.contentMode = .scaleAspectFill
           imageView.layer.cornerRadius = 10
           imageView.clipsToBounds = true
           contentView.addSubview(imageView)
           imageView.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
               imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
               imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
               imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
               imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
           ])
       }

    private func setupRatingBackgroundView() {
        ratingBackgroundView.layer.cornerRadius = 5
        ratingBackgroundView.clipsToBounds = true
        contentView.addSubview(ratingBackgroundView)
        ratingBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ratingBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            ratingBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            ratingBackgroundView.widthAnchor.constraint(equalToConstant: 40),
            ratingBackgroundView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    private func setupRatingLabel() {
        ratingLabel.textColor = .white
        ratingLabel.font = UIFont.boldSystemFont(ofSize: 14)
        ratingLabel.textAlignment = .center
        ratingBackgroundView.addSubview(ratingLabel)
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ratingLabel.topAnchor.constraint(equalTo: ratingBackgroundView.topAnchor),
            ratingLabel.leadingAnchor.constraint(equalTo: ratingBackgroundView.leadingAnchor),
            ratingLabel.trailingAnchor.constraint(equalTo: ratingBackgroundView.trailingAnchor),
            ratingLabel.bottomAnchor.constraint(equalTo: ratingBackgroundView.bottomAnchor)
        ])
    }

    private func setupGradientView() {
        gradientView.layer.cornerRadius = 20
        gradientView.clipsToBounds = true
        contentView.addSubview(gradientView)
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            gradientView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            gradientView.leadingAnchor.constraint(equalTo: ratingLabel.trailingAnchor, constant: 5),
            gradientView.widthAnchor.constraint(equalToConstant: 20),
            gradientView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    private func setupFavoriteButton() {
        favoriteButton.setImage(UIImage(named: "FilledHeart")?.withRenderingMode(.alwaysTemplate), for: .normal)
        favoriteButton.tintColor = .white
        gradientView.addSubview(favoriteButton)
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            favoriteButton.centerXAnchor.constraint(equalTo: gradientView.centerXAnchor),
            favoriteButton.centerYAnchor.constraint(equalTo: gradientView.centerYAnchor),
            favoriteButton.widthAnchor.constraint(equalToConstant: 15),
            favoriteButton.heightAnchor.constraint(equalToConstant: 15)
        ])
    }

    func configure(with movie: MoviesGeneral) {
        imageView.image = movie.poster
        ratingLabel.text = String(format: "%.1f", movie.rating)
        ratingBackgroundView.backgroundColor = colorForRating(movie.rating)
        favoriteButton.setImage(UIImage(named: "FilledHeart")?.withRenderingMode(.alwaysTemplate), for: .normal)
    }

    private func colorForRating(_ rating: Double) -> UIColor {
        switch rating {
        case 0..<4:
            return .red
        case 4..<7:
            return .orange
        case 7...10:
            return .green
        default:
            return .gray
        }
    }
}
