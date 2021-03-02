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
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus"), style: .plain, target: self, action: #selector(handleAddCompany))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset))
        setUpNavigationBar(largeTitleColor: .white, backgoundColor: .lightRed, tintColor: .white, title: "Companies", preferredLargeTitle: true)
    }
    
    /**
     * setting some basic stuff for tableView
     */
    private func setupTableViewUi() {
        tableView.backgroundColor = .darkBlue
        //tableView.separatorStyle = .none
        tableView.separatorColor = .white
        tableView.tableFooterView = UIView()
        tableView.register(CompanyCell.self, forCellReuseIdentifier: "cellId")
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
