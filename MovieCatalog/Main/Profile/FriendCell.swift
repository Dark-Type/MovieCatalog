//
//  FriendCell.swift
//  MovieCatalog
//
//  Created by dark type on 25.10.2024.
//

import UIKit

class FriendCell: UICollectionViewCell {
    static let identifier = "FriendCell"

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 60
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        let textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let deleteButton: UIButton = {
         let button = UIButton(type:.custom)
         button.setImage(UIImage(named: "CancelCross")?.withRenderingMode(.alwaysTemplate), for:.normal)
         button.tintColor = .white
         button.layer.cornerRadius = 15
         button.clipsToBounds = true
         button.translatesAutoresizingMaskIntoConstraints = false
         return button
     }()

     private var gradientLayer: CAGradientLayer?

     override init(frame: CGRect) {
         super.init(frame: frame)
         contentView.addSubview(imageView)
         contentView.addSubview(nameLabel)
         contentView.addSubview(deleteButton)

         NSLayoutConstraint.activate([
             imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
             imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
             imageView.widthAnchor.constraint(equalToConstant: 120),
             imageView.heightAnchor.constraint(equalToConstant: 120),

             nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5),
             nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
             nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

             deleteButton.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 5),
             deleteButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -5),
             deleteButton.widthAnchor.constraint(equalToConstant: 30),
             deleteButton.heightAnchor.constraint(equalToConstant: 30)
         ])
     }

     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }

     override func layoutSubviews() {
         super.layoutSubviews()
         gradientLayer?.frame = deleteButton.bounds
     }

     func configure(with image: UIImage, name: String) {
         imageView.image = image
         nameLabel.text = name
         
         deleteButton.layer.sublayers?.removeAll { $0 is CAGradientLayer }

         let gradientLayer = ColorsEnum.orangeGradient
         gradientLayer.frame = deleteButton.bounds
         deleteButton.layer.insertSublayer(gradientLayer, at: 0)
        
         self.gradientLayer = gradientLayer
     }
 }
