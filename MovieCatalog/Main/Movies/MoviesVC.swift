//
//  FirstVC.swift
//  MovieCatalog
//
//  Created by dark type on 11.10.2024.
//

import UIKit

class MoviesVC: UIViewController {
    // MARK: - Properties

    private var viewModel: MoviesViewModel
    private var timer: Timer?

    private var scrollView: UIScrollView!
    private var contentView: UIView!
    private var contentViewHeightConstraint: NSLayoutConstraint!
    private var featuredFilmsPageViewController: UIPageViewController!
    private var progressBarView: ProgressBarView!
    private var randomMovieImageView: UIImageView!
    private var favoriteMoviesCollectionView: UICollectionView!
    private var allMoviesCollectionView: UICollectionView!
    private var allMoviesCollectionViewHeightConstraint: NSLayoutConstraint!

    // MARK: - Initializer

    init(viewModel: MoviesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindToViewModel()
        addCollectionViewContentSizeObserver()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadInitialData()
    }

    deinit {
        if let collectionView = allMoviesCollectionView {
            collectionView.removeObserver(self, forKeyPath: "contentSize")
        }
    }
}

// MARK: - Setup Methods


private extension MoviesVC {
    func bindToViewModel(){
        viewModel.onMoviesViewModelDidUpdateMovies =  { [weak self] in
            self?.moviesViewModelDidUpdateMovies()
        }
        viewModel.onMoviesViewModelDidUpdateFavoriteMovies =  { [weak self] in
            self?.moviesViewModelDidUpdateFavoriteMovies()
        }
        viewModel.onMoviesViewModelDidUpdateFeaturedMovies =  { [weak self] in
            self?.moviesViewModelDidUpdateFeaturedMovies()
        }
    }
    func setupView() {
        navigationItem.title = ""
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = ColorsEnum.baseDarkGrey

        setupScrollView()
        setupContentView()
        setupPageViewController()
        setupProgressBarView()
        setupRandomMovieImageView()
        setupFavoriteMoviesSection()
        setupAllMoviesSection()

        if let initialViewController = viewControllerAtIndex(0) {
            featuredFilmsPageViewController.setViewControllers([initialViewController], direction: .forward, animated: false, completion: nil)
            progressBarView.updateProgress(index: 0, progress: 1.0)
        }

        startCarouselTimer()
    }

    func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.contentInset.bottom = 100
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func setupContentView() {
        contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)

        contentViewHeightConstraint = contentView.heightAnchor.constraint(equalToConstant: 1500)
        contentViewHeightConstraint.isActive = true

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }

    func setupPageViewController() {
        featuredFilmsPageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil
        )
        featuredFilmsPageViewController.dataSource = self
        featuredFilmsPageViewController.delegate = self
        addChild(featuredFilmsPageViewController)
        contentView.addSubview(featuredFilmsPageViewController.view)
        featuredFilmsPageViewController.didMove(toParent: self)
        featuredFilmsPageViewController.view.translatesAutoresizingMaskIntoConstraints = false

        for gestureRecognizer in featuredFilmsPageViewController.gestureRecognizers {
            gestureRecognizer.delegate = self
        }

        NSLayoutConstraint.activate([
            featuredFilmsPageViewController.view.topAnchor.constraint(equalTo: contentView.topAnchor),
            featuredFilmsPageViewController.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            featuredFilmsPageViewController.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            featuredFilmsPageViewController.view.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
        ])
        for subview in featuredFilmsPageViewController.view.subviews {
                if let pageControl = subview as? UIPageControl {
                    pageControl.isHidden = true
                }
            }
    }

    func setupProgressBarView() {
        progressBarView = ProgressBarView()
        progressBarView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(progressBarView)

        NSLayoutConstraint.activate([
            progressBarView.topAnchor.constraint(equalTo: featuredFilmsPageViewController.view.topAnchor, constant: 10),
            progressBarView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            progressBarView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            progressBarView.heightAnchor.constraint(equalToConstant: 5)
        ])
        progressBarView.setupBars(count: viewModel.featuredMovies.count)
    }

    func setupRandomMovieImageView() {
        randomMovieImageView = UIImageView()
        randomMovieImageView.image = UIImage(named: "RandomFilm")
        randomMovieImageView.contentMode = .scaleAspectFit
        randomMovieImageView.isUserInteractionEnabled = true
        randomMovieImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(randomMovieImageView)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(randomMovieImageTapped))
        randomMovieImageView.addGestureRecognizer(tapGesture)

        NSLayoutConstraint.activate([
            randomMovieImageView.topAnchor.constraint(equalTo: featuredFilmsPageViewController.view.bottomAnchor, constant: 20),
            randomMovieImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            randomMovieImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            randomMovieImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }

    func setupFavoriteMoviesSection() {
        let favoriteMoviesLabel = createSectionLabel(text: "Мне нравится")
        contentView.addSubview(favoriteMoviesLabel)
        

        NSLayoutConstraint.activate([
            favoriteMoviesLabel.topAnchor.constraint(equalTo: randomMovieImageView.bottomAnchor, constant: 20),
            favoriteMoviesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20)
        ])

        let allLabel = createSectionLabel(text: "Все")
        allLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(allLabelTapped))
        allLabel.addGestureRecognizer(tapGesture)
        contentView.addSubview(allLabel)

        NSLayoutConstraint.activate([
            allLabel.centerYAnchor.constraint(equalTo: favoriteMoviesLabel.centerYAnchor),
            allLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10

        favoriteMoviesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        favoriteMoviesCollectionView.dataSource = self
        favoriteMoviesCollectionView.delegate = self
        favoriteMoviesCollectionView.register(FavoriteMovieCell.self, forCellWithReuseIdentifier: "FavoriteMovieCell")
        favoriteMoviesCollectionView.showsHorizontalScrollIndicator = false
        favoriteMoviesCollectionView.backgroundColor = ColorsEnum.baseDarkGrey
        favoriteMoviesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        favoriteMoviesCollectionView.tag = 0
        contentView.addSubview(favoriteMoviesCollectionView)

        NSLayoutConstraint.activate([
            favoriteMoviesCollectionView.topAnchor.constraint(equalTo: favoriteMoviesLabel.bottomAnchor, constant: 10),
            favoriteMoviesCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            favoriteMoviesCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            favoriteMoviesCollectionView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }

    func setupAllMoviesSection() {
        let allMoviesLabel = createSectionLabel(text: "Все фильмы")
        contentView.addSubview(allMoviesLabel)
       

        NSLayoutConstraint.activate([
            allMoviesLabel.topAnchor.constraint(equalTo: favoriteMoviesCollectionView.bottomAnchor, constant: 20),
            allMoviesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20)
        ])

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10

        allMoviesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        allMoviesCollectionView.dataSource = self
        allMoviesCollectionView.delegate = self
        allMoviesCollectionView.isScrollEnabled = false
        allMoviesCollectionView.register(AllMovieCell.self, forCellWithReuseIdentifier: "AllMovieCell")
        allMoviesCollectionView.showsVerticalScrollIndicator = false
        allMoviesCollectionView.backgroundColor = ColorsEnum.baseDarkGrey
        allMoviesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        allMoviesCollectionView.tag = 1
        contentView.addSubview(allMoviesCollectionView)

        allMoviesCollectionViewHeightConstraint = allMoviesCollectionView.heightAnchor.constraint(equalToConstant: 200)
        allMoviesCollectionViewHeightConstraint.isActive = true

        NSLayoutConstraint.activate([
            allMoviesCollectionView.topAnchor.constraint(equalTo: allMoviesLabel.bottomAnchor, constant: 10),
            allMoviesCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            allMoviesCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    func addCollectionViewContentSizeObserver() {
        allMoviesCollectionView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }

    func createSectionLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}

// MARK: - Action Methods

private extension MoviesVC {
    @objc func randomMovieImageTapped() {
        viewModel.selectRandomMovie()
    }

    @objc func allLabelTapped() {
        viewModel.selectAllMovies()
    }

    @objc func openMovieDetail() {
        guard !viewModel.featuredMovies.isEmpty else { return }
        let movie = viewModel.featuredMovies[viewModel.currentPageIndex]
        viewModel.delegate?.moviesCoordinatorDidSelectMovie(movie)
    }

    @objc func genreButtonTapped(_ sender: MCGenreButton) {
        let genre = sender.genre
        ServiceManager.shared.genresService.toggleFavoriteStatus(for: genre)
        sender.updateAppearance()
    }

    func updateGenreButtonBackground(_ button: MCButton, isFavorite: Bool) {
        if isFavorite {
            button.layer.insertSublayer(ColorsEnum.orangeGradient(), at: 0)
        } else {
            button.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
            button.backgroundColor = .clear
        }
    }
}

// MARK: - Observer Methods

extension MoviesVC {
    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey: Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        if keyPath == "contentSize",
           let newSize = change?[.newKey] as? CGSize
        {
            updateCollectionViewHeight(newHeight: newSize.height + 570)
            updateContentViewHeight()
        }
    }

    func updateCollectionViewHeight(newHeight: CGFloat) {
        allMoviesCollectionViewHeightConstraint.constant = newHeight
        view.layoutIfNeeded()
    }

    func updateContentViewHeight() {
        let totalHeight = featuredFilmsPageViewController.view.frame.height +
            randomMovieImageView.frame.height +
            favoriteMoviesCollectionView.frame.height +
            allMoviesCollectionView.frame.height +
            60
        contentViewHeightConstraint.constant = totalHeight
        view.layoutIfNeeded()
    }
}

// MARK: - Timer Methods

private extension MoviesVC {
    func startCarouselTimer() {
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(changeFeaturedMovie), userInfo: nil, repeats: true)
    }

    func resetCarouselTimer() {
        timer?.invalidate()
        startCarouselTimer()
    }

    @objc func changeFeaturedMovie() {
        guard !viewModel.featuredMovies.isEmpty else { return }
        viewModel.currentPageIndex = (viewModel.currentPageIndex + 1) % viewModel.featuredMovies.count
        if viewModel.currentPageIndex == 0 {
            progressBarView.clearBars()
            progressBarView.setupBars(count: viewModel.featuredMovies.count)
        }
        guard let viewController = viewControllerAtIndex(viewModel.currentPageIndex) else { return }
        featuredFilmsPageViewController.setViewControllers([viewController], direction: .forward, animated: true, completion: nil)
        progressBarView.updateProgress(index: viewModel.currentPageIndex, progress: 1.0)
    }
}

// MARK: - UIPageViewControllerDataSource & Delegate

extension MoviesVC: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    private func viewControllerAtIndex(_ index: Int) -> UIViewController? {
        guard index >= 0 && index < viewModel.featuredMovies.count else { return nil }
        let movie = viewModel.featuredMovies[index]
        let viewController = UIViewController()
        viewController.view.backgroundColor = .clear

        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = movie.poster
        imageView.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: viewController.view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor)
        ])

        imageView.layer.cornerRadius = 20
        imageView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        imageView.clipsToBounds = true

        let overlayView = UIView()
        overlayView.backgroundColor = .clear
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.addSubview(overlayView)

        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: viewController.view.topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor)
        ])
        
        let watchButton = MCButton(title: "Смотреть", fontSize: 18, isActive: true)
        watchButton.addTarget(self, action: #selector(openMovieDetail), for: .touchUpInside)
        watchButton.translatesAutoresizingMaskIntoConstraints = false
        overlayView.addSubview(watchButton)

        
        watchButton.clipsToBounds = true

        NSLayoutConstraint.activate([
            watchButton.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor, constant: -20),
            watchButton.bottomAnchor.constraint(equalTo: overlayView.bottomAnchor, constant: -20),
            watchButton.widthAnchor.constraint(equalTo: overlayView.widthAnchor, multiplier: 0.3),
            watchButton.heightAnchor.constraint(equalToConstant: 50)
        ])

        let nameLabel = UILabel()
        nameLabel.text = movie.name
        nameLabel.textColor = .white
        nameLabel.font = UIFont.boldSystemFont(ofSize: 24)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        overlayView.addSubview(nameLabel)

        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor, constant: 20),
            nameLabel.bottomAnchor.constraint(equalTo: watchButton.topAnchor, constant: -20),
            nameLabel.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor, constant: -20)
        ])

        let genresContainer = UIView()
        genresContainer.translatesAutoresizingMaskIntoConstraints = false
        overlayView.addSubview(genresContainer)

        NSLayoutConstraint.activate([
            genresContainer.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor, constant: 20),
            genresContainer.trailingAnchor.constraint(equalTo: watchButton.leadingAnchor, constant: -20),
            genresContainer.bottomAnchor.constraint(equalTo: overlayView.bottomAnchor, constant: -20),
            genresContainer.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10)
        ])

        var previousGenreButton: MCGenreButton?
        for (index, genre) in movie.genres.enumerated() {
            let genreButton = MCGenreButton(genre: genre)
            genreButton.addTarget(self, action: #selector(genreButtonTapped(_:)), for: .touchUpInside)
            genresContainer.addSubview(genreButton)

            genreButton.clipsToBounds = true

            genreButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                genreButton.widthAnchor.constraint(equalTo: genresContainer.widthAnchor, multiplier: 0.5, constant: -5),
                genreButton.heightAnchor.constraint(equalToConstant: 30)
            ])

            if index % 2 == 0 {
                genreButton.leadingAnchor.constraint(equalTo: genresContainer.leadingAnchor).isActive = true
            } else {
                genreButton.leadingAnchor.constraint(equalTo: previousGenreButton!.trailingAnchor, constant: 10).isActive = true
            }

            if index < 2 {
                genreButton.topAnchor.constraint(equalTo: genresContainer.topAnchor).isActive = true
            } else {
                genreButton.topAnchor.constraint(equalTo: previousGenreButton!.bottomAnchor, constant: 10).isActive = true
            }

            previousGenreButton = genreButton
        }

        return viewController
    }
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return viewModel.featuredMovies.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return viewModel.currentPageIndex
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        let previousIndex = viewModel.currentPageIndex - 1
        guard previousIndex >= 0 else { return nil }
        progressBarView.goToPreviousBar(index: viewModel.currentPageIndex)
        viewModel.currentPageIndex = previousIndex
        resetCarouselTimer()
        return viewControllerAtIndex(previousIndex)
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        let nextIndex = viewModel.currentPageIndex + 1
        guard nextIndex < viewModel.featuredMovies.count else { return nil }
        progressBarView.goToNextBar(index: viewModel.currentPageIndex)
        viewModel.currentPageIndex = nextIndex
        resetCarouselTimer()
        return viewControllerAtIndex(nextIndex)
    }
}

// MARK: - UICollectionViewDataSource & Delegate

extension MoviesVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        if collectionView == favoriteMoviesCollectionView {
            return viewModel.favoriteMovies.count
        } else if collectionView == allMoviesCollectionView {
            return viewModel.allMovies.count
        }
        return 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        if collectionView == favoriteMoviesCollectionView {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "FavoriteMovieCell",
                for: indexPath
            ) as! FavoriteMovieCell
            let movie = viewModel.favoriteMovies[indexPath.item]
            cell.configure(with: movie)
            return cell
        } else if collectionView == allMoviesCollectionView {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "AllMovieCell",
                for: indexPath
            ) as! AllMovieCell
            let movie = viewModel.allMovies[indexPath.item]
            cell.configure(with: movie)
            return cell
        }
        return UICollectionViewCell()
    }

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        viewModel.selectMovie(at: indexPath, in: collectionView)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        if collectionView == favoriteMoviesCollectionView {
            return CGSize(width: 120, height: 180)
        } else {
            return CGSize(width: 100, height: 150)
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 2
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 10
    }
}

// MARK: - UIScrollViewDelegate

extension MoviesVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        if offsetY > contentHeight - height - 100 {
            viewModel.loadMovies()
        }
    }
}

// MARK: - MoviesViewModelDelegate

private extension MoviesVC {
    func moviesViewModelDidUpdateMovies() {
        DispatchQueue.main.async {
            self.allMoviesCollectionView.reloadData()
            self.allMoviesCollectionView.layoutIfNeeded()
            self.updateContentViewHeight()
        }
    }

    func moviesViewModelDidUpdateFavoriteMovies() {
        DispatchQueue.main.async {
            self.favoriteMoviesCollectionView.reloadData()
        }
    }

    func moviesViewModelDidUpdateFeaturedMovies() {
        DispatchQueue.main.async {
            self.setupFeaturedMovies()
        }
    }

    func setupFeaturedMovies() {
        guard let initialViewController = viewControllerAtIndex(0) else { return }
        featuredFilmsPageViewController.setViewControllers([initialViewController], direction: .forward, animated: false, completion: nil)
        progressBarView.setupBars(count: viewModel.featuredMovies.count)
    }
}

// MARK: - UIGestureRecognizerDelegate

extension MoviesVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        return true
    }
}
