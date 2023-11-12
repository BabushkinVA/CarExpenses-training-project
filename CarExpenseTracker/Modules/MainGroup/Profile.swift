//
//  Profile.swift
//  CarExpenseTracker
//
//  Created by Vadim on 8.10.23.
//

import UIKit

struct CarProfile: Codable {
    
    var make: String
    var model: String
    
    init(make: String, model: String) {
        self.make = make
        self.model = model
    }
    
}
