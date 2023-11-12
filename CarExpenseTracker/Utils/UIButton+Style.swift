//
//  UIButton+Style.swift
//  CarExpenseTracker
//
//  Created by Vadim on 8.10.23.
//

import UIKit

extension UIButton {
    
    func buttonMainStyle() {
        self.layer.cornerRadius = 10.0
        self.setTitleColor(.white, for: .normal)
        self.tintColor = UIColor.white
        self.backgroundColor = .systemOrange
    }
    
    func cancelButtonStyle() {
        self.setTitleColor(.systemOrange, for: .normal)
        self.setTitle("Cancel", for: .normal)
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20.0)
        self.backgroundColor = .clear
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.systemOrange.cgColor
        self.layer.cornerRadius = 10.0
    }
    
    func saveButtonStyle() {
        self.setTitleColor(.appBlack, for: .normal)
        self.setTitle("Save", for: .normal)
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20.0)
        self.backgroundColor = .systemOrange
        self.layer.cornerRadius = 10.0
    }
}
