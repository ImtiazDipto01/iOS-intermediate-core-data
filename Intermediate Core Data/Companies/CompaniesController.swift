//
//  ViewController.swift
//  Intermediate Core Data
//
//  Created by Imtiaz Uddin Ahmed on 1/11/20.
//  Copyright © 2020 Imtiaz. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class CompaniesController: UITableViewController {
    
    var companies = [Company]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        self.companies = CoreDataManager.shared.fetchCompanies()
        setupTableViewUi()
        
        // setting up Navigation Bar and Bar Item
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset)),
            UIBarButtonItem(title: "Nested Updates", style: .plain, target: self, action: #selector(doNestedUpdates))
        ]
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus"), style: .plain, target: self, action: #selector(handleAddCompany))
        setUpNavigationBar(largeTitleColor: .white, backgoundColor: .lightRed, tintColor: .white, title: "Companies", preferredLargeTitle: true)
    }
    
    /**
     * setting some basic stuff for tableView
     */
    private func setupTableViewUi() {
        tableView.backgroundColor = .darkBlue
        //tableView.separatorStyle = .none
        tableView.bounces = true
        tableView.separatorColor = .white
        tableView.tableFooterView = UIView()
        tableView.register(CompanyCell.self, forCellReuseIdentifier: "cellId")
    }

    
    /**
     * in this method we're inserting random company items into coredata using background thread
     * and updating our table view update the insertation
     * N.B : this method is just a example method for practice not will going to work for production.
     */
    @objc private func doBackgroundWork() {
        
        CoreDataManager.shared.persistentContainer.performBackgroundTask { (backgroundContext) in
            (0...5).forEach { (value) in
                
                let company = Company(context: backgroundContext)
                company.name = String(value)
                print(value)
            }
            do{
                try backgroundContext.save()
                
                DispatchQueue.main.async {
                    self.companies = CoreDataManager.shared.fetchCompanies()
                    self.tableView.reloadData()
                }
            } catch let saveErr {
                print("Failed to Save Company", saveErr)
            }
        }
        
        // background work running with GCD - Grand Central Dispatch
        DispatchQueue.global(qos: .background).async {
            (0...20000).forEach { (value) in
                //print(value)
            }
        }
    }
    
    
    /**
     * in this method we're updating all company items into coredata using background thread
     * and updating our table view update the insertation
     * N.B : this method is just a example method for practice not will going to work for production.
     */
    @objc private func doUpdates() {
        print("Trying to update companies on a background thread")
        
        CoreDataManager.shared.persistentContainer.performBackgroundTask { (backgroundContext) in
            
            let request: NSFetchRequest<Company> = Company.fetchRequest()
            
            do{
                let companies = try backgroundContext.fetch(request)
                companies.forEach { (company) in
                    print(company.name ?? "")
                    company.name = "C : \(company.name ?? "")"
                }
                
                do {
                    try backgroundContext.save()
                    
                    DispatchQueue.main.async {
                        CoreDataManager.shared.persistentContainer.viewContext.reset()
                        self.companies = CoreDataManager.shared.fetchCompanies()
                        self.tableView.reloadData()
                    }
                    
                } catch let saveErr {
                    print("Failed to save on Background:", saveErr)
                }
                
            } catch let err {
                print("Failed to fetch companies on background:", err)
            }
            
        }
    }
    
    
    @objc private func doNestedUpdates() {
        print("Trying to do Nested update companies on a background thread")
        
        DispatchQueue.global(qos: .background).async {
           
            // create a child context and attach with it to a parent context
            let dbChildContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            dbChildContext.parent = CoreDataManager.shared.persistentContainer.viewContext
            
            // create a fetch request
            let request: NSFetchRequest<Company> = Company.fetchRequest()
            request.fetchLimit = 1
            
            
            do {
                
                // fetch the required data from db
                let companies = try dbChildContext.fetch(request)
                companies.forEach { (company) in
                    print(company.name ?? "")
                    
                    // updating a exiting data
                    company.name = "Imtiaz : \(company.name ?? "")"
                }
                
                do {
                    // saving the new updating data using childContext and also need to save the update parent conetxt
                    try dbChildContext.save()
                    
                    
                    // need to Landed to main thread for updating tableview and getting parent context
                    DispatchQueue.main.async {
                        do {
                            
                            // getting parent context here
                            let parentConext = CoreDataManager.shared.persistentContainer.viewContext
                            if(parentConext.hasChanges) {
                                try parentConext.save() // saving updates to parent context
                            }
                            self.tableView.reloadData() // updating tableview 
                            
                        } catch let parentSaveErr {
                            print("Failed to save update using parent Conetxt:", parentSaveErr)
                        }
                    }
                    
                } catch let saveErr {
                    print("Failed to save update using child Conetxt:", saveErr)
                }
                
            } catch let err {
                print("Failed to fetch on private context:", err)
            }
            
        }
        
    }

    @objc private func handleReset() {
        print("Delete All The Core data objects")
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let batchDeleteReq = NSBatchDeleteRequest(fetchRequest: Company.fetchRequest())
        
        do {
            try context.execute(batchDeleteReq)
            
            var indexPathToRemove = [IndexPath]()
            for (index, _) in companies.enumerated() {
                let indexPath = IndexPath(row: index, section: 0)
                indexPathToRemove.append(indexPath)
            }
            
            companies.removeAll()
            tableView.deleteRows(at: indexPathToRemove, with: .left)
            
            //tableView.reloadData() // use it when you directly reload the tableview without any animation
        }
        catch let delErr {
            print("Failed to delete object from coe data \(delErr)")
        }
        
    }
    
    @objc private func handleAddCompany() {
        let createCompanyController = CreateCompanyController()
        let navController = CustomNavigationController(rootViewController: createCompanyController)
        navController.modalPresentationStyle = .fullScreen
        createCompanyController.createCompanyDelegate = self
        
        present(navController, animated: true, completion: nil)
    }
    
}
