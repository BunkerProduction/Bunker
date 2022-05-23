//
//  SplittedDigitInput.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 07.05.2022.
//

import UIKit

final class SplittedDigitInput: UIView {
    private let titleLabel = UILabel()
    private let backTextField = UITextField()
    private var labels: [DigitLabel] = []
    private let numberOfDigits = 6
    private var isInputWrong: Bool = false
    private var isPresenting: Bool = false
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupTextField()
        setupView()
    }
    
    init(isPresenting: Bool) {
        super.init(frame: .zero)
        self.isPresenting = isPresenting
        
        if(!isPresenting) {
            setupTextField()
        }
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI setup
    private func setupView() {
        self.layer.cornerRadius = 12
        
        titleLabel.text = "Enter room number"
        titleLabel.textAlignment = .center
        titleLabel.font = .customFont.body
        
        for _ in 0...numberOfDigits-1 {
            let label = DigitLabel()
            label.backgroundColor = .white
            label.textColor = .black
            label.font = .customFont.headline
            labels.append(label)
        }
        
        let digitSV = UIStackView(arrangedSubviews: labels)
        digitSV.distribution = .fillEqually
        digitSV.alignment = .fill
        digitSV.axis = .horizontal
        digitSV.spacing = 8
        digitSV.setHeight(to: 42)
        
        let mainSV = UIStackView(arrangedSubviews: [titleLabel, digitSV])
        mainSV.distribution = .fill
        mainSV.alignment = .fill
        mainSV.axis = .vertical
        mainSV.spacing = 12
        
        self.addSubview(mainSV)
        mainSV.pin(to: self, [.left: 47, .right: 47, .bottom: 24, .top: 16])
    }
    
    private func setupTextField() {
        self.addSubview(backTextField)
        backTextField.pin(to: self)
        backTextField.keyboardType = .numberPad
        backTextField.alpha = 0
        backTextField.becomeFirstResponder()
        backTextField.delegate = self
        backTextField.addTarget(self, action: #selector(setLabels), for: .editingChanged)
    }
    
    @objc
    private func setLabels() {
        var i = 0
        if(backTextField.text?.count == numberOfDigits) {
            backTextField.resignFirstResponder()
        }
        guard let localdigits = backTextField.text else { return }
        for number in localdigits {
            labels[i].text = String(number)
            i = i + 1
        }
        
        for i in localdigits.count..<numberOfDigits {
            labels[i].text = ""
        }
    }
    
    // MARK: - Interactions
    public func toggleInput(_ isWrong: Bool) {
        if(isInputWrong == false && isWrong == false) {
            return
        } else {
            isInputWrong.toggle()
        }
        
        for label in labels {
            label.switchState()
        }
    }
    
    public func DismissKeyboard() {
        self.backTextField.resignFirstResponder()
    }
    
    public func showKeyboard() {
        self.backTextField.becomeFirstResponder()
    }
    
    public func setTheme(_ theme: Appearence) {
        self.backgroundColor = .Background.Accent.colorFor(theme)
        self.titleLabel.textColor = .TextAndIcons.Secondary.colorFor(theme)
        for label in labels {
            label.backgroundColor = .Background.LayerTwo.colorFor(theme)
            label.textColor = .TextAndIcons.Primary.colorFor(theme)
        }
    }
    
    public func setValues(_ str: String) {
        backTextField.text = str
        setLabels()
    }
    
    public func getValue() -> String {
        return backTextField.text ?? ""
    }
    
    public func setTitleLabel(_ str: String) {
        self.titleLabel.text = str
    }
}

// MARK: - TextFieldDelegate
extension SplittedDigitInput: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.toggleInput(false)
        if range.location > numberOfDigits - 1 {
            textField.text?.removeLast()
        }
        return true
    }
}


// MARK: - Custom Label
final class DigitLabel: UILabel {
    private var isRed: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        font = UIFont(name: font.fontName, size: 28)
        layer.masksToBounds = true
        layer.cornerRadius = 8
        textAlignment = .center
    }
    
    public func switchState() {
        isRed.toggle()
        
        if(isRed) {
            self.layer.borderColor = UIColor.Main.Warning.colorFor(.toxic)?.cgColor
            self.layer.borderWidth = 1.5
        } else {
            self.layer.borderWidth = 0
        }
    }
}

