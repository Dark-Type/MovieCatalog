//
//  FriendsListVC.swift
//  MovieCatalog
//
//  Created by dark type on 25.10.2024.
//
import UIKit

class FriendsListVC: UIViewController {
    var friends: [(image: UIImage, name: String)] = [
        (UIImage(named: "Poster1")!, "Dark Type"),
        (UIImage(named: "Poster1")!, "Dark Type"),
        (UIImage(named: "Poster1")!, "Dark Type"),
        (UIImage(named: "Poster1")!, "Dark Type"),
        (UIImage(named: "Poster1")!, "Dark Type"),
        (UIImage(named: "Poster1")!, "Dark Type"),
        (UIImage(named: "Poster1")!, "Dark Type")
    ]

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(FriendCell.self, forCellWithReuseIdentifier: FriendCell.identifier)
        return collectionView
    }()

    override func viewDidLoad() {
           super.viewDidLoad()
           setupBackgroundColor()
           hidesBottomBarWhenPushed = true
           setupNavigationBar()
           setupCollectionView()
       }

       private func setupBackgroundColor() {
           view.backgroundColor = ColorsEnum.baseDarkGrey
       }

    private func setupNavigationBar() {
        var configuration = UIButton.Configuration.filled()
        configuration.image = UIImage(named: "ChevronLeft")?.withTintColor(.white)
        configuration.baseBackgroundColor = ColorsEnum.baseGrey
        configuration.cornerStyle = .medium
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)

        let goBackButton = UIButton(configuration: configuration)
        goBackButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)

        let barButtonItem = UIBarButtonItem(customView: goBackButton)
        navigationItem.leftBarButtonItem = barButtonItem
    }

    @objc private func goBack() {
        navigationController?.popViewController(animated: true)
    }

    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension FriendsListVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return friends.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FriendCell.identifier, for: indexPath) as! FriendCell
        let friend = friends[indexPath.item]
        cell.configure(with: friend.image, name: friend.name)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 10
        let availableWidth = collectionView.frame.width - padding * 4
        let width = availableWidth / 3
        return CGSize(width: width, height: width + 30)
    }
}
