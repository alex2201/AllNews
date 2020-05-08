//
//  ManagedObjectModel.swift
//  SchoolCam
//
//  Created by Alexander Lopez Cedillo on 07/03/20.
//  Copyright © 2020 Alexander Lopez Cedillo. All rights reserved.
//

import UIKit
import CoreData

class ManagedObjectModel {
    // MARK: - Public properties
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	
    // MARK: - Methods
	func saveContext(){
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
	}
}
