//
//  MCTextField.swift
//  MovieCatalog
//
//  Created by dark type on 12.10.2024.
//

import UIKit

class MCTextField: MCBaseTextField {
    override func setupTextField(hintText: String) {
        super.setupTextField(hintText: hintText)
        addClearButton()
        addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }

    private func addClearButton() {
        let clearButton = UIButton(type: .custom)
        clearButton.setImage(UIImage(named: "CancelCross")!.withTintColor(.white), for: .normal)
        clearButton.addTarget(self, action: #selector(clearText), for: .touchUpInside)
        clearButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        clearButton.contentMode = .center
        rightView = clearButton
        updateClearButtonVisibility()
    }

    @objc private func clearText() {
        text = ""
        updateClearButtonVisibility()
    }

    @objc private func textDidChange() {
        updateClearButtonVisibility()
    }

    private func updateClearButtonVisibility() {
        rightViewMode = (text?.isEmpty ?? true) ? .never : .always
    }

    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        let originalRect = super.rightViewRect(forBounds: bounds)
        return originalRect.offsetBy(dx: -15, dy: 0)
    }
}
