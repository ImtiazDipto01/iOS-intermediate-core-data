//
//  CoreDataManager.swift
//  Intermediate Core Data
//
//  Created by Imtiaz Uddin Ahmed on 10/2/21.
//  Copyright © 2021 Imtiaz. All rights reserved.
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
    
    
    func fetchCompanies() -> [Company] {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
        
        do{
            let companies = try context.fetch(fetchRequest)
            
            /*companies.forEach { (company) in
                print(company.name ?? "")
            }*/
            return companies
            
        }catch let fetchErr {
            print("Failed to fetch Companies:", fetchErr)
            return []
        }
    }
    
    
    func fetchEmployees() -> [Employee] {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Employee>(entityName: "Employee")
        
        do {
            let employee = try context.fetch(fetchRequest)
            return employee
            
        } catch let fetchErr {
            print("Failed to fetch Employee:", fetchErr)
            return []
        }
    }
    
    
    func createEmployee(name: String, birthDayDate: Date, company: Company) -> (Employee?, Error?) {
        let context = persistentContainer.viewContext
        
        let employee = NSEntityDescription.insertNewObject(forEntityName: "Employee", into: context) as! Employee
        
        employee.setValue(name, forKey: "name")
        
        let employeeInformation = NSEntityDescription.insertNewObject(forEntityName: "EmployeeInformation", into: context) as! EmployeeInformation
        employeeInformation.taxId = "456"
        
        employee.employeeInformation = employeeInformation
        employee.company = company
        employee.employeeInformation?.birthday = birthDayDate
        
        
        do {
            try context.save()
            return (employee, nil)
            
        } catch let err {
            print("Failed to create employee:", err) 
            return (nil, err)
        }
    }
}
