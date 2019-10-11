//
//  PasswordField.swift
//  PasswordTextField
//
//  Created by Ben Gohlke on 6/26/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class PasswordField: UIControl {
    
    // Public API - these properties are used to fetch the final password and strength values
    private (set) var password: String = ""
    
    private let standardMargin: CGFloat = 8.0
    private let textFieldContainerHeight: CGFloat = 50.0
    private let textFieldMargin: CGFloat = 6.0
    private let colorViewSize: CGSize = CGSize(width: 60.0, height: 5.0)
    
    private let labelTextColor = UIColor(hue: 233.0/360.0, saturation: 16/100.0, brightness: 41/100.0, alpha: 1)
    private let labelFont = UIFont.systemFont(ofSize: 14.0, weight: .semibold)
//    MARK: - TextField & View Attributes
    private let textFieldBorderColor = UIColor(hue: 208/360.0, saturation: 80/100.0, brightness: 94/100.0, alpha: 1)
    private let bgColor = UIColor(hue: 0, saturation: 0, brightness: 97/100.0, alpha: 1)
    
    // MARK: - States of the password strength indicators
    private let unusedColor = UIColor(hue: 210/360.0, saturation: 5/100.0, brightness: 86/100.0, alpha: 1)
    private let weakColor = UIColor(hue: 0/360, saturation: 60/100.0, brightness: 90/100.0, alpha: 1)
    private let mediumColor = UIColor(hue: 39/360.0, saturation: 60/100.0, brightness: 90/100.0, alpha: 1)
    private let strongColor = UIColor(hue: 132/360.0, saturation: 60/100.0, brightness: 75/100.0, alpha: 1)
    
//    MARK: - Properties
    private var titleLabel: UILabel = UILabel()
    private var textField: UITextField = UITextField()
    private var showHideButton: UIButton = UIButton()
    private var weakView: UIView = UIView()
    private var mediumView: UIView = UIView()
    private var strongView: UIView = UIView()
    private var strengthDescriptionLabel: UILabel = UILabel()
    private var showingPassword = false
    
//    MARK: - Methods
    
    @objc func showHideButtonTapped(_sender: UIButton) {
        showingPassword.toggle()
        showHideButton.setImage(UIImage(named: (showingPassword) ? "eyes-open" : "eyes-closed"), for: .normal)
        textField.isSecureTextEntry = !showingPassword
    }
    
    func setup() {
        // Lay out your subviews here
        backgroundColor = bgColor

//            adding label of enter Password
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: standardMargin).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: standardMargin).isActive = true
        titleLabel.text = " Enter Password"
        titleLabel.font = labelFont
        titleLabel.textColor = labelTextColor
        
//        adding TextField, adding constraints, adding the border to the textfield
        let textFieldContainerView = UIView()
        addSubview(textFieldContainerView)
        textFieldContainerView.backgroundColor = .clear
        textFieldContainerView.layer.borderColor = textFieldBorderColor.cgColor
        textFieldContainerView.layer.borderWidth = 2.0
        textFieldContainerView.layer.cornerRadius = 5.0
        textFieldContainerView.translatesAutoresizingMaskIntoConstraints = false
        textFieldContainerView.topAnchor.constraint(equalToSystemSpacingBelow: titleLabel.bottomAnchor, multiplier: 1.0).isActive = true
        textFieldContainerView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: textFieldContainerView.trailingAnchor, constant: standardMargin).isActive = true

        textFieldContainerView.addSubview(textField)
        textField.delegate = self
        textField.tintColor = textFieldBorderColor
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isSecureTextEntry = !showingPassword
        textField.topAnchor.constraint(equalTo: textFieldContainerView.topAnchor, constant: textFieldMargin).isActive = true
        textField.leadingAnchor.constraint(equalTo: textFieldContainerView.leadingAnchor, constant: textFieldMargin).isActive = true
        textFieldContainerView.bottomAnchor.constraint(equalTo: textField.bottomAnchor, constant: textFieldMargin).isActive = true
        
//         textfield is see/hidden when entering password
        textFieldContainerView.addSubview(showHideButton)
        showHideButton.translatesAutoresizingMaskIntoConstraints = false
        showHideButton.setImage(UIImage(named: "eyes-closed"), for: .normal)
        showHideButton.centerYAnchor.constraint(equalTo: textField.centerYAnchor).isActive = true
        showHideButton.leadingAnchor.constraint(equalTo: textField.trailingAnchor, constant: textFieldMargin).isActive = true
        textFieldContainerView.trailingAnchor.constraint(equalTo: showHideButton.trailingAnchor, constant: textFieldMargin).isActive = true
        showHideButton.addTarget(self, action: #selector(showHideButtonTapped(_sender:)), for: .touchUpInside)
        
//        password strengh indicators
        weakView.translatesAutoresizingMaskIntoConstraints = false
        weakView.backgroundColor
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
}

//      MARK: - Extention
extension PasswordField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        // TODO: send new text to the determine strength method
        return true
    }
}
