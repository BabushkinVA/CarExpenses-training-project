//
//  UIVC + func.swift
//  CarExpenseTracker
//
//  Created by Vadim on 8.10.23.
//

import UIKit

extension UIViewController {
    
    func totalMileage() -> Int32 {
        var result: Int32 = 0
        var minOdo: Int32 = 0
        var maxOdo: Int32 = 0
        
        let fuelOdoRequest = FuelMO.fetchRequest()
        let serviceOdoRequest = ServiceMO.fetchRequest()
        
        let fueoOdo = (try? CoreDataService.context.fetch(fuelOdoRequest)) ?? []
        let minFuelOdo = fueoOdo.sorted{ $0.odometer < $1.odometer }.first?.odometer
        let maxFuelOdo = fueoOdo.sorted{ $0.odometer < $1.odometer }.last?.odometer
        
        let servOdo = (try? CoreDataService.context.fetch(serviceOdoRequest)) ?? []
        let minServOdo = servOdo.sorted{ $0.odometer < $1.odometer }.first?.odometer
        let maxServOdo = servOdo.sorted{ $0.odometer < $1.odometer }.last?.odometer
        
        if let minFuel = minFuelOdo,
           let maxFuel = maxFuelOdo,
           let minServ = minServOdo,
           let maxServ = maxServOdo {
            
            minFuel <= minServ ? (minOdo = minFuel) : (minOdo = minServ)
            maxFuel >= maxServ ? (maxOdo = maxFuel) : (maxOdo = maxServ)
            result = maxOdo - minOdo
            
        } else if let minFuel = minFuelOdo,
                  let maxFuel = maxFuelOdo {
            result = maxFuel - minFuel
            
        } else if let minServ = minServOdo,
                  let maxServ = maxServOdo {
            result = maxServ - minServ
        }
        
        return result
    }

}
