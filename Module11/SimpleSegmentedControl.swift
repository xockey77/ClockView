//
//  SimpleSegmentedControl.swift
//  Module11
//
//  Created by username on 18.11.2021.
//

import UIKit

// создать собственный аналог UISegmentControl, у которого:
// всегда есть два возможных варианта сегмента;
// выбранный элемент (по умолчанию — первый) имеет цветную подложку,
// при нажатии на второй сегмент подложка перемещается под него с анимацией, и наоборот;
// в интерфейсе можно задать названия сегментов, цвет обводки и цвет подложки;
// есть делегат, через который он будет сообщать о выбранном сегменте.

@IBDesignable
class SimpleSegmentedControl: UIView, ShadowedButtonDelegate {
    
    var delegate: SimpleSegmentedControlDelegate?
    var selectedSegmentIndex: Int = 0
    let buttonL = ShadowedButton()
    let buttonR = ShadowedButton()
    var selectorView: UIView!
    var isSetuped: Bool = false
    
    @IBInspectable var leftTitle: String = "" {
        didSet {
            buttonL.setTitle(leftTitle)
        }
    }
    
    @IBInspectable var rightTitle: String = "" {
        didSet {
            buttonR.setTitle(rightTitle)
        }
    }
    
    @IBInspectable var borderColor: UIColor = .systemGray
    @IBInspectable var selectorViewColor: UIColor = .systemYellow

    override func draw(_ rect: CGRect) {
        if isSetuped {
            return
        }
        isSetuped = true
        buttonL.delegate = self
        buttonR.delegate = self

        layer.borderWidth = 3
        layer.borderColor = borderColor.cgColor
        layer.cornerRadius = frame.height / 4
       
        selectorView = UIView(frame: CGRect(x: 0, y: layer.borderWidth, width: frame.width / 2, height: frame.height - 2 * layer.borderWidth))
        selectorView.backgroundColor = selectorViewColor
        selectorView.setRadiusWithShadow(frame.height / 4, CGSize(width: 5, height: 5), 5, 1.0)
        addSubview(selectorView)
        
        let stackView = UIStackView(arrangedSubviews: [buttonL, buttonR])
        
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        buttonL.setTextColor(to: .white)
        buttonR.setTextColor(to: .systemGray)
        buttonL.setTitle(leftTitle)
        buttonR.setTitle(rightTitle)
    }

    func buttonPressed(_ sender: ShadowedButton) {
        switch sender {
        case buttonL:
            selectedSegmentIndex = 0
            UIView.animate(withDuration: 0.25, animations: {
                self.selectorView.frame.origin.x = 0
            })
            buttonL.setTextColor(to: .white)
            buttonR.setTextColor(to: .systemGray)
            break
        case buttonR:
            selectedSegmentIndex = 1
            UIView.animate(withDuration: 0.25, animations: {
                self.selectorView.frame.origin.x = self.frame.width / 2
            })
            buttonL.setTextColor(to: .systemGray)
            buttonR.setTextColor(to: .white)
            break
        default:
            break
        }
        self.delegate?.selectedIndex = selectedSegmentIndex
    }
}
