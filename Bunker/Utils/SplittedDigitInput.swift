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
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupTextField()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI setup
    private func setupView() {
        self.backgroundColor = .Background.accent
        self.layer.cornerRadius = 12
        
        titleLabel.text = "Введите номер комнаты"
        titleLabel.textAlignment = .center
        
        for _ in 0...numberOfDigits-1 {
            let label = DigitLabel()
            label.backgroundColor = .white
            label.textColor = .black
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
        mainSV.pin(to: self, [.left: 47, .right: 47, .bottom: 16, .top: 16])
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
        layer.masksToBounds = true
        layer.cornerRadius = 8
        textAlignment = .center
    }
    
    public func switchState() {
        isRed.toggle()
        
        if(isRed) {
            self.layer.borderColor = UIColor.red.cgColor
            self.layer.borderWidth = 2
        } else {
            self.layer.borderWidth = 0
        }
    }
}

