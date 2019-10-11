//
//  PasswordField.swift
//  PasswordTextField
//
//  Created by Ben Gohlke on 6/26/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

enum PasswordStrength: String {
    case tooWeak = "Too Weak"
    case couldBeStronger = "Could Be Stronger"
    case strong = " Strong Password"
}

class PasswordField: UIControl {
    
    private(set) var passwordStrength: PasswordStrength? {
        didSet {
            changeStrengthBarColor()
        }
    }
    
    // Public API - these properties are used to fetch the final password and strength values
    private (set) var password: String = "" {
        didSet {
            determinePasswordStrength()
        }
    }
//    MARK: - Properties
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

//            MARK: - Adding label for Password entry
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: standardMargin).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: standardMargin).isActive = true
        titleLabel.text = " Enter Password"
        titleLabel.font = labelFont
        titleLabel.textColor = labelTextColor
        
//        MARK: - Adding TextField, adding constraints, adding the border to the textfield
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
        textField.placeholder = "Password"
//         MARK: - Textfield is see/hidden when entering password
        textFieldContainerView.addSubview(showHideButton)
        showHideButton.translatesAutoresizingMaskIntoConstraints = false
        showHideButton.setImage(UIImage(named: "eyes-closed"), for: .normal)
        showHideButton.centerYAnchor.constraint(equalTo: textField.centerYAnchor).isActive = true
        showHideButton.leadingAnchor.constraint(equalTo: textField.trailingAnchor, constant: textFieldMargin).isActive = true
        textFieldContainerView.trailingAnchor.constraint(equalTo: showHideButton.trailingAnchor, constant: textFieldMargin).isActive = true
        showHideButton.addTarget(self, action: #selector(showHideButtonTapped(_sender:)), for: .touchUpInside)
        
//        MARK: - Password Strengh Indicators, visual Setup
        
        addSubview(weakView)
        weakView.translatesAutoresizingMaskIntoConstraints = false
        weakView.backgroundColor = weakColor
        weakView.widthAnchor.constraint(equalToConstant: colorViewSize.width).isActive = true
        weakView.heightAnchor.constraint(equalToConstant: colorViewSize.height).isActive = true
        weakView.layer.cornerRadius = colorViewSize.height / 2
        
        addSubview(mediumView)
        mediumView.translatesAutoresizingMaskIntoConstraints = false
        mediumView.backgroundColor = unusedColor
        mediumView.widthAnchor.constraint(equalToConstant: colorViewSize.width).isActive = true
        mediumView.heightAnchor.constraint(equalToConstant: colorViewSize.height).isActive = true
        mediumView.layer.cornerRadius = colorViewSize.height / 2
        
        addSubview(strongView)
        strongView.translatesAutoresizingMaskIntoConstraints = false
        strongView.backgroundColor = unusedColor
        strongView.widthAnchor.constraint(equalToConstant: colorViewSize.width).isActive = true
        strongView.heightAnchor.constraint(equalToConstant: colorViewSize.height).isActive = true
        strongView.layer.cornerRadius = colorViewSize.height / 2
        
//        MARK: - Putting Indicators in Stackview
        
        let colorStackView = UIStackView(arrangedSubviews: [weakView, mediumView, strongView])
        addSubview(colorStackView)
        colorStackView.translatesAutoresizingMaskIntoConstraints = false
        colorStackView.axis = .horizontal
        colorStackView.alignment = .fill
        colorStackView.distribution = .fill
        colorStackView.spacing = 2.0
        colorStackView.topAnchor.constraint(equalTo: textFieldContainerView.bottomAnchor, constant: 16).isActive = true
        colorStackView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        
//        MARK: - Strength Description Label
        
        addSubview(strengthDescriptionLabel)
        strengthDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        strengthDescriptionLabel.leadingAnchor.constraint(equalTo: colorStackView.trailingAnchor, constant: standardMargin).isActive = true
        strengthDescriptionLabel.centerYAnchor.constraint(equalTo: colorStackView.centerYAnchor).isActive = true
        bottomAnchor.constraint(equalTo: strengthDescriptionLabel.bottomAnchor, constant: standardMargin).isActive = true
        strengthDescriptionLabel.text = "Too Weak"
        strengthDescriptionLabel.font = labelFont
        strengthDescriptionLabel.textColor = labelTextColor
         }
// MARK: - Initializer
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        textField.delegate = self
    }
    // MARK: - Determing Password Strength
    
    private func determinePasswordStrength() {
        if password.count <= 9 {
            passwordStrength = .tooWeak
        } else if (10...19).contains(password.count) {
            passwordStrength = .couldBeStronger
        } else {
            passwordStrength = .strong
        }
        
//        MARK: ATTEMPED Stretch Goal
//        if UIReferenceLibraryViewController.dictionaryHasDefinition(forTerm: string) {
//        let weaker = passwordStrength.rawValue - 1
//        passwordStrength = PasswordStrength(rawValue: weaker >= 1) ? weaker : 1)!
//    }
//        changeStrengthBarColor(to: passwordStrength)
//        }
        
        
    }
//    MARK: - Changing the Strengthbar Color
    private func changeStrengthBarColor() {
        if let passwordStrength = passwordStrength,
            let input = textField.text,
            !input.isEmpty {
            switch passwordStrength {
            case .tooWeak:
                weakView.backgroundColor = weakColor
                strengthDescriptionLabel.text = passwordStrength.rawValue
                mediumView.backgroundColor = unusedColor
                strongView.backgroundColor = unusedColor
            case .couldBeStronger:
                weakView.backgroundColor = weakColor
                mediumView.backgroundColor = mediumColor
                strongView.backgroundColor = unusedColor
                strengthDescriptionLabel.text = passwordStrength.rawValue
            case .strong:
                weakView.backgroundColor = weakColor
                mediumView.backgroundColor = mediumColor
                strongView.backgroundColor = strongColor
                strengthDescriptionLabel.text = passwordStrength.rawValue
            }
        } else {
            [weakView,mediumView,strongView].forEach { $0.backgroundColor = unusedColor}
        }
}

}
//      MARK: - Extention
extension PasswordField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        // MARK: send new text to the determine strength method
        password = newText
        return true
    }
//    MARK: - Makes Textfield the first responder the type in text
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
