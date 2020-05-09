//
//  SourceEntity+CoreDataProperties.swift
//  
//
//  Created by Alexander Lopez Cedillo on 09/05/20.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension SourceEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SourceEntity> {
        return NSFetchRequest<SourceEntity>(entityName: "SourceEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var language: String?

}
