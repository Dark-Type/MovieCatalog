//
//  MCPasswordTextField.swift
//  MovieCatalog
//
//  Created by dark type on 12.10.2024.
//

import UIKit

class MCPasswordTextField: MCBaseTextField {
    private var isSecure: Bool = true
    private var toggleButton: UIButton?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupToggleButton()
        addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(fontColor: UIColor? = .white, hintColor: UIColor? = .lightGray, hintText: String, padding: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)) {
        self.init()
        self.fontColor = fontColor
        self.hintColor = hintColor
        self.padding = padding
        setupToggleButton()
        setupTextField(hintText: hintText)
        addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }

    override func setupTextField(hintText: String) {
        super.setupTextField(hintText: hintText)
        isSecureTextEntry = true
    }

    @objc private func togglePassword(_ sender: UIButton) {
        isSecure.toggle()
        if isSecure {
            self.isSecureTextEntry = true
            sender.setImage(UIImage(named: "NotVisible")?.withTintColor(.white), for: .normal)
        } else {
            self.isSecureTextEntry = false
            sender.setImage(UIImage(named: "Visible")?.withTintColor(.white), for: .normal)
        }
    }

    @objc private func textDidChange() {
        updateToggleButtonVisibility()
    }

    private func updateToggleButtonVisibility() {
        rightViewMode = (text?.isEmpty ?? true) ? .never : .always
    }

    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        let originalRect = super.rightViewRect(forBounds: bounds)
        return originalRect.offsetBy(dx: -15, dy: 0)
    }
}

extension MCPasswordTextField {
    private func setupToggleButton() {
        toggleButton = UIButton(type: .custom)
        toggleButton?.setImage(UIImage(named: "NotVisible")?.withTintColor(.white), for: .normal)
        toggleButton?.addTarget(self, action: #selector(togglePassword), for: .touchUpInside)
        toggleButton?.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        toggleButton?.contentMode = .center
        toggleButton?.tintColor = .gray
        rightView = toggleButton
        updateToggleButtonVisibility()
    }
}
