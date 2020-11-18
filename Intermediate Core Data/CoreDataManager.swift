//
//  CoreDataManager.swift
//  Intermediate Core Data
//
//  Created by Imtiaz Uddin Ahmed on 18/11/20.
//  Copyright © 2020 Imtiaz. All rights reserved.
//

import CoreData

struct CoreDataManager {
    
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer = {
        // intializing core data stack
        let container = NSPersistentContainer(name: "IntermediateTrainingModel")
        container.loadPersistentStores { (storeDescription, err) in
            
            if let err = err {
                fatalError("Loading of store failed \(err)")
            }
        }
        return container
    }()
}
