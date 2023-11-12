//
//  UIColor+Const.swift
//  CarExpenseTracker
//
//  Created by Vadim on 2.11.23.
//

import UIKit

extension UIColor {
    
    private convenience init(_ r: UInt8, _ g: UInt8, _ b: UInt8, _ a: CGFloat) {
        self.init(red: CGFloat(r) / 255.0,
                  green: CGFloat(g) / 255.0,
                  blue: CGFloat(b) / 255.0,
                  alpha: a)
    }
    
    static var appBlack: UIColor = .init(40, 40, 40, 1)

}
