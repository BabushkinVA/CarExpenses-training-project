//
//  FuelMO+CoreDataProperties.swift
//  CarExpenseTracker
//
//  Created by Vadim on 11.11.23.
//
//

import Foundation
import CoreData


extension FuelMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FuelMO> {
        return NSFetchRequest<FuelMO>(entityName: "FuelMO")
    }

    @NSManaged public var date: String?
    @NSManaged public var liters: Double
    @NSManaged public var odometer: Int32
    @NSManaged public var oneLiter: Double
    @NSManaged public var price: Double

}

extension FuelMO : Identifiable {

}
