//
//  MCEmailTextField.swift
//  MovieCatalog
//
//  Created by dark type on 13.10.2024.
//

import UIKit

class MCEmailTextField: MCTextField {
    override func setupTextField(hintText: String) {
        super.setupTextField(hintText: hintText)
        addClearButton()
        addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        keyboardType = .emailAddress
    }

    private func addClearButton() {
        let clearButton = UIButton(type: .custom)
        clearButton.setImage(UIImage(named: "CancelCross")!.withTintColor(.white), for: .normal)
        clearButton.addTarget(self, action: #selector(clearEmailText), for: .touchUpInside)
        clearButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        clearButton.contentMode = .center
        rightView = clearButton
    }

    func isValid() -> Bool {
        return isValidEmail() ?? false
    }

    @objc private func clearEmailText() {
        text = ""
    }

    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        let originalRect = super.rightViewRect(forBounds: bounds)
        return originalRect
    }

    func isValidEmail() -> Bool? {
        guard let email = text, !email.isEmpty else { return nil }
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    @objc private func textFieldDidChange() {
        updateOutline()
    }

    private func updateOutline() {
        if let isValid = isValidEmail() {
            if isValid {
                layer.borderWidth = 0
                layer.borderColor = UIColor.clear.cgColor
            } else {
                layer.borderWidth = 2
                layer.borderColor = UIColor.red.cgColor
            }
        } else {
            layer.borderWidth = 0
            layer.borderColor = UIColor.clear.cgColor
        }
    }
}
