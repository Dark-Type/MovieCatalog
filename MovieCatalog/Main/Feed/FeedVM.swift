//
//  FeedVM.swift
//  MovieCatalog
//
//  Created by dark type on 27.10.2024.
//

import UIKit

class FeedVM {
    var onUpdateTopCardView: ((SwipeCardView?) -> Void)?
    var onUpdateBottomCardView: ((SwipeCardView?) -> Void)?
    var onEncounterError: ((Error) -> Void)?
    var onUpdateMovieInfo: ((FeedMovie?) -> Void)?

    private var movies: [FeedMovie] = []
    private var cardQueue: [FeedMovie] = []
    private var shownMovies: Set<String> = []

    private(set) var topCardView: SwipeCardView?
    private(set) var bottomCardView: SwipeCardView?

    private var isLoading = false
    private var currentPage = 1
    private let moviesPerPage = 6

    private var swipeCounter = 0

    init() {
        loadShownMovies()
        loadMovies()
    }

    private func loadMovies() {
        guard !isLoading else { return }
        isLoading = true

        ServiceManager.shared.movieService.fetchFeedMovies(page: currentPage) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false

            switch result {
            case .success(let feedMovies):
                let newMovies = feedMovies.filter { !self.shownMovies.contains($0.id) }
                self.movies.append(contentsOf: newMovies)
                self.cardQueue.append(contentsOf: newMovies)
                self.currentPage += 1

                if self.topCardView == nil, self.bottomCardView == nil {
                    self.setupInitialCards()
                }
            case .failure(let error):
                self.onEncounterError?(error)
            }
        }
    }

    private func setupInitialCards() {
        guard !cardQueue.isEmpty else {
            onUpdateTopCardView?(nil)
            onUpdateBottomCardView?(nil)
            onUpdateMovieInfo?(nil)
            return
        }

        if let topMovie = cardQueue.first {
            cardQueue.removeFirst()
            let topCard = createCardView(with: topMovie)
            topCardView = topCard
            onUpdateTopCardView?(topCard)
            onUpdateMovieInfo?(topMovie)
        }

        if let bottomMovie = cardQueue.first {
            cardQueue.removeFirst()
            let bottomCard = createCardView(with: bottomMovie)
            bottomCardView = bottomCard
            onUpdateBottomCardView?(bottomCard)
        }
    }

    private func createCardView(with movie: FeedMovie) -> SwipeCardView {
        let cardView = SwipeCardView()
        cardView.movie = movie
        cardView.onSwipe = { [weak self] in
            self?.handleSwipe()
        }
        cardView.onFavorite = { [weak self] in
            self?.addToFavorites(movie: movie)
        }
        cardView.onHide = { [weak self] in
            self?.hideMovie(movie: movie)
        }
        return cardView
    }

    private func handleSwipe() {
        if let topMovie = topCardView?.movie {
            shownMovies.insert(topMovie.id)
            saveShownMovies()
        }

        topCardView?.removeFromSuperview()

        if let bottomCardView = bottomCardView {
            let newTopCardView = createCardView(with: bottomCardView.movie ?? cardQueue.first!)
            topCardView = newTopCardView
            onUpdateTopCardView?(newTopCardView)
            onUpdateMovieInfo?(newTopCardView.movie)
            self.bottomCardView = nil
        } else {
            topCardView = nil
            onUpdateTopCardView?(nil)
            onUpdateMovieInfo?(nil)
        }

        if let nextMovie = cardQueue.first {
            cardQueue.removeFirst()
            let newBottomCard = createCardView(with: nextMovie)
            bottomCardView = newBottomCard
            onUpdateBottomCardView?(newBottomCard)
            if (cardQueue.first == nil) {
                loadMovies()
            }
        } else {
            bottomCardView = nil
            onUpdateBottomCardView?(nil)
        }
        swipeCounter += 1
        print("Swipe Count: \(swipeCounter)")

        if swipeCounter >= 3 {
            swipeCounter = 0
            loadMovies()
        }
    }

    private func saveShownMovies() {
        ServiceManager.shared.shownMoviesService.addShownMovie(topCardView?.movie?.id ?? "")
    }

    private func loadShownMovies() {
        shownMovies = ServiceManager.shared.shownMoviesService.getShownMovies()
    }

    func addToFavorites(movie: FeedMovie) {
        ServiceManager.shared.movieService.addFavoriteMovie(movieId: movie.id) { result in
            switch result {
            case .success:
                print("Successfully added to favorites: \(movie.name)")
            case .failure(let error):
                print("Failed to add to favorites: \(error.localizedDescription)")
            }
        }
    }

    func hideMovie(movie: FeedMovie) {
        HiddenFilmsService.shared.hideFilm(withId: movie.id)
        ServiceManager.shared.movieService.deleteFavoriteMovie(movieId: movie.id) { result in
            switch result {
            case .success:
                print("Successfully hidden and removed from favorites: \(movie.name)")
            case .failure(let error):
                print("Failed to remove from favorites: \(error.localizedDescription)")
            }
        }
    }
}
