//
//  MCDatePicker.swift
//  MovieCatalog
//
//  Created by dark type on 12.10.2024.
//

import UIKit

enum MCDatePickerResources {
    static let padding: CGFloat = 10
    static let cornerRadius: CGFloat = 8
    static let backgroundColor = ColorsEnum.baseGrey
    static let textFieldPlaceholder = "Дата рождения"
    static let calendarImage = UIImage(named: "Calendar")
    static let textFieldTextColor = UIColor.white
    static let textFieldPlaceholderColor = ColorsEnum.greyFaded
    static let datePickerTextColor = ColorsEnum.greyFaded
}

protocol MCDatePickerDelegate: AnyObject {
    func datePickerDidChange(_ datePicker: MCDatePicker, date: Date)
}

class MCDatePicker: UIView {
    weak var delegate: MCDatePickerDelegate?

    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        return picker
    }()

    private let textField: UITextField = {
        let field = UITextField()
        field.placeholder = MCDatePickerResources.textFieldPlaceholder
        field.textColor = MCDatePickerResources.textFieldPlaceholderColor
        return field
    }()

    private let calendarImageView: UIImageView = {
        let imageView = UIImageView(image: MCDatePickerResources.calendarImage?.withTintColor(MCDatePickerResources.textFieldPlaceholderColor))
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
        addTapGesture()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func getDate() -> Date? {
        return datePicker.date
    }

    func setDate(_ date: Date, animated: Bool) {
        datePicker.setDate(date, animated: animated)
        updateTextField()
    }

    private func setupView() {
        backgroundColor = MCDatePickerResources.backgroundColor
        layer.cornerRadius = MCDatePickerResources.cornerRadius
        clipsToBounds = true

        setupCalendarImageView()
        setupDatePicker()
        updateTextFieldColor()
    }

    @objc private func dateChanged() {
        updateTextField()
        delegate?.datePickerDidChange(self, date: datePicker.date)
    }

    private func updateTextField() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        textField.text = formatter.string(from: datePicker.date)
        updateTextFieldColor()
    }

    private func updateTextFieldColor() {
        if textField.text?.isEmpty ?? true {
            textField.textColor = MCDatePickerResources.textFieldPlaceholderColor
        } else {
            textField.textColor = MCDatePickerResources.textFieldTextColor
        }
    }

    private func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
    }

    @objc private func handleTap() {
        textField.becomeFirstResponder()
    }

    private func setupCalendarImageView() {
        calendarImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(calendarImageView)
    }

    private func setupDatePicker() {
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        textField.inputView = datePicker
    }

    private func setupConstraints() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textField)

        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: MCDatePickerResources.padding),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -MCDatePickerResources.padding),
            textField.topAnchor.constraint(equalTo: topAnchor, constant: MCDatePickerResources.padding),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -MCDatePickerResources.padding),

            calendarImageView.trailingAnchor.constraint(equalTo: textField.trailingAnchor, constant: -MCDatePickerResources.padding),
            calendarImageView.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
            calendarImageView.widthAnchor.constraint(equalToConstant: 24),
            calendarImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
}
