//
//  RoundedButton.swift
//  Module11
//
//  Created by username on 14.11.2021.
//

import UIKit

//создать кнопку, у которой можно изменять ширину и цвет обводки, размер закругления;

@IBDesignable
class RoundedButton: UIButton {
    
    
    @IBInspectable var borderColor: UIColor = .green
    
    @IBInspectable var borderWidth: CGFloat = 2.0 {
        didSet {
            if borderWidth < 0 {
                borderWidth = oldValue
            }
        }
    }

    @IBInspectable var cornerRadius: CGFloat = 15.0 {
        didSet {
            if cornerRadius < 0 {
                cornerRadius = oldValue
            } else if cornerRadius > min(bounds.width, bounds.height) / 2 {
                cornerRadius = min(bounds.width, bounds.height) / 2
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.setTitleColor(.systemBackground, for: .normal)
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
    }
    
}
