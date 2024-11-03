//
//  MCGoBackButton.swift
//  MovieCatalog
//
//  Created by dark type on 23.10.2024.
//

import UIKit

class MCGoBackButton: UIView {
    let button: UIButton
    let label: UILabel

    init(image: UIImage?, labelText: String) {
        button = UIButton(type: .system)
        label = UILabel()

        super.init(frame: .zero)

        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.backgroundColor = ColorsEnum.baseGrey
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false

        label.text = labelText
        label.font = UIFont.systemFont(ofSize: 32)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false

        addSubview(button)
        addSubview(label)

        translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.centerYAnchor.constraint(equalTo: centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 40),
            button.heightAnchor.constraint(equalToConstant: 40),

            label.leadingAnchor.constraint(equalTo: button.trailingAnchor, constant: 15),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        bringSubviewToFront(button)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
