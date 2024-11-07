//
//  FriendsListVC.swift
//  MovieCatalog
//
//  Created by dark type on 25.10.2024.
//
import UIKit

class FriendsListVC: UIViewController {
    var currentUserLogin: String?
    var friends: [AuthorDetails] = []
    let friendsLabel = UILabel()
    let goBackButton = UIButton()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 20
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
        fetchFriends()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let tabBar = tabBarController?.tabBar {
            tabBar.isHidden = true
        }
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func fetchFriends() {
        friends = FriendsService.shared.getFriends()
        collectionView.reloadData()
    }
    
    private func setupBackgroundColor() {
        view.backgroundColor = ColorsEnum.baseDarkGrey
    }
    
    private func setupNavigationBar() {
        navigationItem.hidesBackButton = true

        var configuration = UIButton.Configuration.filled()
        configuration.image = UIImage(named: "ChevronLeft")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        configuration.baseBackgroundColor = ColorsEnum.baseGrey
        configuration.cornerStyle = .medium
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
        configuration.imagePadding = 6

        goBackButton.configuration = configuration
        goBackButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        goBackButton.translatesAutoresizingMaskIntoConstraints = false

        let goBackBarButtonItem = UIBarButtonItem(customView: goBackButton)

        friendsLabel.text = "Мои друзья"
        friendsLabel.textColor = .white
        friendsLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        friendsLabel.translatesAutoresizingMaskIntoConstraints = false
        friendsLabel.backgroundColor = .clear

        let labelBarButtonItem = UIBarButtonItem(customView: friendsLabel)

        navigationItem.leftBarButtonItems = [goBackBarButtonItem, labelBarButtonItem]
    }
    
    @objc private func goBack() {
        if let tabBar = tabBarController?.tabBar {
            tabBar.isHidden = false
        }
        navigationController?.popViewController(animated: true)
    }

    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
        ])
    }
}

extension FriendsListVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, FriendCellDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if friends.isEmpty {
            let label = UILabel(frame: collectionView.bounds)
            label.text = "No friends added yet."
            label.textAlignment = .center
            label.textColor = .white
            collectionView.backgroundView = label
        } else {
            collectionView.backgroundView = nil
        }
        return friends.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FriendCell.identifier, for: indexPath) as! FriendCell
        let friend = friends[indexPath.item]
        cell.configure(with: friend)
        cell.delegate = self
        return cell
    }
    
    func didTapDeleteButton(on cell: FriendCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let friend = friends[indexPath.item]
        let alert = UIAlertController(title: "Remove Friend", message: "Do you want to remove \(friend.nickName ?? "this friend")?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Remove", style: .destructive) { _ in
            self.removeFriend(friend)
        })
        present(alert, animated: true)
    }
    
    private func removeFriend(_ friend: AuthorDetails) {
        FriendsService.shared.removeFriend(byUserId: friend.userId ?? "propId")
        if let index = friends.firstIndex(where: { $0.userId == friend.userId }) {
            friends.remove(at: index)
            collectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 10
        let availableWidth = collectionView.frame.width - padding * 4
        let width = availableWidth / 3
        return CGSize(width: width, height: 130)
    }
}
