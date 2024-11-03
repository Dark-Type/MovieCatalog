//
//  MCBaseTextField.swift
//  MovieCatalog
//
//  Created by dark type on 12.10.2024.
//

import UIKit

class MCBaseTextField: UITextField {
    var fontColor: UIColor?
    var hintColor: UIColor?
    var padding: UIEdgeInsets

    override init(frame: CGRect) {
        self.padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        super.init(frame: frame)
        setupTextField(hintText: "Hint")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(fontColor: UIColor? = .white, hintColor: UIColor? = ColorsEnum.greyFaded, hintText: String, padding: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 40)) {
        self.init()
        self.fontColor = fontColor
        self.hintColor = hintColor
        self.padding = padding
    
        setupTextField(hintText: hintText)
    }

    internal func setupTextField(hintText: String) {
        configureAppearance()
        configurePlaceholder(hintText: hintText)
    }

   
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
extension MCBaseTextField {
    private func configureAppearance() {
        backgroundColor = ColorsEnum.baseGrey
        layer.cornerRadius = 8
        clipsToBounds = true
        textColor = fontColor ?? .white
    }

    private func configurePlaceholder(hintText: String) {
        placeholder = hintText
        attributedPlaceholder = NSAttributedString(string: hintText, attributes: [
            .foregroundColor: hintColor ?? ColorsEnum.subTitleGrey,
            .font: font ?? UIFont.systemFont(ofSize: 12)
        ])
    }

}
