//
//  dismissKeyboard.swift
//  MovieCatalog
//
//  Created by dark type on 13.10.2024.
//

import UIKit
extension UIViewController {
    func setupTapGestureToDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
