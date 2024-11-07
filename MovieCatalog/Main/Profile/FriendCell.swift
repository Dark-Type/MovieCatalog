//
//  FriendCell.swift
//  MovieCatalog
//
//  Created by dark type on 25.10.2024.
//

import UIKit

protocol FriendCellDelegate: AnyObject {
    func didTapDeleteButton(on cell: FriendCell)
}

class FriendCell: UICollectionViewCell {
    static let identifier = "FriendCell"
    
    weak var delegate: FriendCellDelegate?
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 40
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        contentView.layer.cornerRadius = 0
        
        contentView.addSubview(imageView)
        contentView.addSubview(deleteButton)
        contentView.addSubview(nameLabel)
        
        setupDeleteButton()
        setupConstraints()
        
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
    
    @objc private func deleteButtonTapped() {
        delegate?.didTapDeleteButton(on: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupDeleteButton() {
        deleteButton.setImage(UIImage(named: "DeleteButton"), for: .normal)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80),

            deleteButton.topAnchor.constraint(equalTo: imageView.topAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 24),
            deleteButton.heightAnchor.constraint(equalToConstant: 24),

            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            nameLabel.heightAnchor.constraint(equalToConstant: 22)
        ])
    }
    
    func configure(with friend: AuthorDetails) {
        nameLabel.text = friend.nickName ?? "Unknown"
        if let avatarURLString = friend.avatar, !avatarURLString.isEmpty {
            ImageService.shared.fetchImage(from: avatarURLString) { [weak self] result in
                switch result {
                case .success(let image):
                    DispatchQueue.main.async {
                        self?.imageView.image = image
                    }
                case .failure:
                    DispatchQueue.main.async {
                        self?.imageView.image = UIImage(systemName: "person.crop.circle")
                    }
                }
            }
        } else {
            imageView.image = UIImage(systemName: "person.crop.circle")
        }
    }
}
