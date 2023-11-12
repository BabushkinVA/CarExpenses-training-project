//
//  ServiceMO+CoreDataProperties.swift
//  CarExpenseTracker
//
//  Created by Vadim on 11.11.23.
//
//

import Foundation
import CoreData


extension ServiceMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ServiceMO> {
        return NSFetchRequest<ServiceMO>(entityName: "ServiceMO")
    }

    @NSManaged public var amount: Double
    @NSManaged public var category: String?
    @NSManaged public var date: String?
    @NSManaged public var myDescription: String?
    @NSManaged public var name: String?
    @NSManaged public var odometer: Int32
    @NSManaged public var shortDescript: String?

}

extension ServiceMO : Identifiable {

}
