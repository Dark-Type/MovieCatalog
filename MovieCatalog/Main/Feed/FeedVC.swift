//
//  SecondVC.swift
//  MovieCatalog
//
//  Created by dark type on 11.10.2024.
//

import UIKit

enum FeedVCConstants {
    static let logoImageName = "LogoImage"
    static let noMoreCardsText = "No more cards"
    static let logoTopAnchorConstant: CGFloat = -20
    static let logoHeightWidthConstant: CGFloat = 100
    static let nameLabelFontSize: CGFloat = 24
    static let nameLabelBottomAnchorConstant: CGFloat = -10
    static let dateCountryLabelBottomAnchorConstant: CGFloat = -10
    static let genresStackViewBottomAnchorConstant: CGFloat = -20
    static let cardViewX: CGFloat = 20
    static let cardViewY: CGFloat = 180
    static let cardViewWidthOffset: CGFloat = 40
    static let cardViewHeightOffset: CGFloat = 400
    static let genreLabelTopBottomConstant: CGFloat = 10
    static let genreLabelLeadingTrailingConstant: CGFloat = 10
    static let genreViewWidthConstant: CGFloat = 50
    static let genreViewHeightConstant: CGFloat = 40
}

class FeedVC: UIViewController {
    private var viewModel: FeedVM

    private var topCardView: SwipeCardView?
    private var bottomCardView: SwipeCardView?

    private let logoImageView = UIImageView()
    private let nameLabel = UILabel()
    private let dateCountryLabel = UILabel()
    private let genresStackView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorsEnum.baseDarkGrey
        setupLogo()
        setupLabels()
        bindToViewModel()
    }

    init(viewModel: FeedVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLogo() {
        logoImageView.image = UIImage(named: FeedVCConstants.logoImageName)
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImageView)

        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: FeedVCConstants.logoTopAnchorConstant),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: FeedVCConstants.logoHeightWidthConstant),
            logoImageView.widthAnchor.constraint(equalToConstant: FeedVCConstants.logoHeightWidthConstant)
        ])
    }

    private func setupLabels() {
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont.systemFont(ofSize: FeedVCConstants.nameLabelFontSize)
        nameLabel.textColor = .white
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        dateCountryLabel.textAlignment = .center
        dateCountryLabel.textColor = ColorsEnum.subTitleGrey
        dateCountryLabel.translatesAutoresizingMaskIntoConstraints = false

        genresStackView.axis = .horizontal
        genresStackView.spacing = 8
        genresStackView.alignment = .center
        genresStackView.distribution = .equalCentering
        genresStackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(nameLabel)
        view.addSubview(dateCountryLabel)
        view.addSubview(genresStackView)

        NSLayoutConstraint.activate([
            nameLabel.bottomAnchor.constraint(equalTo: dateCountryLabel.topAnchor, constant: -20),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            dateCountryLabel.bottomAnchor.constraint(equalTo: genresStackView.topAnchor, constant: -20),
            dateCountryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dateCountryLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            genresStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            genresStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            genresStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            genresStackView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    private func bindToViewModel() {
        viewModel.onUpdateTopCardView = { [weak self] topCardView in
            DispatchQueue.main.async {
                guard let self = self else { return }

                self.topCardView?.removeFromSuperview()
                self.topCardView = topCardView

                if let topCard = topCardView {
                    topCard.translatesAutoresizingMaskIntoConstraints = false
                    self.view.addSubview(topCard)
                    self.view.bringSubviewToFront(topCard)

                    topCard.onFavorite = { [weak self] in
                        guard let self = self, let movie = topCard.movie else { return }
                        self.viewModel.addToFavorites(movie: movie)
                    }

                    topCard.onHide = { [weak self] in
                        guard let self = self, let movie = topCard.movie else { return }
                        self.viewModel.hideMovie(movie: movie)
                    }

                    NSLayoutConstraint.activate([
                        topCard.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                        topCard.topAnchor.constraint(equalTo: self.logoImageView.bottomAnchor, constant: 20),
                        topCard.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8),
                        topCard.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.5)
                    ])
                }
            }
        }

        viewModel.onUpdateBottomCardView = { [weak self] bottomCardView in
            DispatchQueue.main.async {
                guard let self = self else { return }

                self.bottomCardView?.removeFromSuperview()
                self.bottomCardView = bottomCardView

                if let bottomCard = bottomCardView {
                    bottomCard.translatesAutoresizingMaskIntoConstraints = false
                    if let topCard = self.topCardView {
                        self.view.insertSubview(bottomCard, belowSubview: topCard)
                    } else {
                        self.view.addSubview(bottomCard)
                    }

                    NSLayoutConstraint.activate([
                        bottomCard.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                        bottomCard.topAnchor.constraint(equalTo: self.logoImageView.bottomAnchor, constant: 20),
                        bottomCard.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8),
                        bottomCard.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.5)
                    ])
                }
            }
        }

        viewModel.onEncounterError = { [weak self] error in
            DispatchQueue.main.async {
                guard let self = self else { return }

                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }

        viewModel.onUpdateMovieInfo = { [weak self] movie in
            DispatchQueue.main.async {
                self?.updateMovieInfo(with: movie)
            }
        }
    }

    private func displayNoMoreCards() {
        topCardView?.removeFromSuperview()
        bottomCardView?.removeFromSuperview()
        topCardView = nil
        bottomCardView = nil

        nameLabel.isHidden = true
        dateCountryLabel.isHidden = true
        genresStackView.isHidden = true

        let noMoreCardsLabel = UILabel()
        noMoreCardsLabel.text = FeedVCConstants.noMoreCardsText
        noMoreCardsLabel.textColor = .white
        noMoreCardsLabel.textAlignment = .center
        noMoreCardsLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        noMoreCardsLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(noMoreCardsLabel)

        NSLayoutConstraint.activate([
            noMoreCardsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noMoreCardsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func updateMovieInfo(with movie: FeedMovie?) {
        guard let movie = movie else {
            displayNoMoreCards()
            return
        }

        nameLabel.isHidden = false
        dateCountryLabel.isHidden = false
        genresStackView.isHidden = false

        nameLabel.text = movie.name
        dateCountryLabel.text = "\(movie.country) • \(movie.year)"
        updateGenres(genres: movie.genres)
    }

    private func updateGenres(genres: [Genre]) {
        genresStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for genre in genres {
            let genreButton = MCGenreButton(genre: genre)
            genresStackView.addArrangedSubview(genreButton)

            NSLayoutConstraint.activate([
                genreButton.heightAnchor.constraint(equalToConstant: 30)
            ])
        }
    }
}
