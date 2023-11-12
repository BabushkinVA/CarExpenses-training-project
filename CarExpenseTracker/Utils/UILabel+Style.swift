//
//  UILabel+Style.swift
//  CarExpenseTracker
//
//  Created by Vadim on 9.10.23.
//

import UIKit

extension UILabel {
    
    func labelMainStyle(_ textSize: CGFloat) {
        self.textColor = .white
        self.textAlignment = .left
        self.font = UIFont.systemFont(ofSize: textSize, weight: .medium)
    }
    
}
