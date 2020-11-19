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

class CompaniesController: UITableViewController, CreateCompanyControllerDelegate {
    
    func didAddCompany(company: Company) {
        
        companies.append(company)
        let newIndexPath = IndexPath(row: companies.count - 1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    
    func fetchCompanies(){
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
        
        do{
            let companies = try context.fetch(fetchRequest)
            
            companies.forEach { (company) in
                print(company.name ?? "")
            }
            
            self.companies = companies
            self.tableView.reloadData()
            
        }catch let fetchErr {
            print("Failed to fetch Companies:", fetchErr)
        }
        
    }
    
    var companies = [Company]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        fetchCompanies()
        
        view.backgroundColor = .white
        
        // setting some basic stuff for tableView
        tableView.backgroundColor = .darkBlue
        //tableView.separatorStyle = .none
        tableView.separatorColor = .white
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        
        // setting up Navigation Bar and Bar Item
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus"), style: .plain, target: self, action: #selector(handleAddCompany))
        configureNavigationBar(largeTitleColor: .white, backgoundColor: .lightRed, tintColor: .white, title: "Companies", preferredLargeTitle: true)
    }
    
    
    @objc func handleAddCompany() {
        
        let createCompanyController = CreateCompanyController()
        
        let navController = CustomNavigationController(rootViewController: createCompanyController)
        navController.modalPresentationStyle = .fullScreen
        
        createCompanyController.createCompanyDelegate = self
        
        present(navController, animated: true, completion: nil)
        
    }
    
    /* TableView Setup Start */
    
    /**
     * Returning a UIView, If you need a header of your each section
     */
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .lightBlue
        return view
    }
    
    /**
     * Returning CGFloat value, for specifing a height of the header.
     */
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    /**
     * Setting up swipe actions and Returting those swipe action items
     */
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteItem = UIContextualAction(style: .destructive, title: "Delete") { (action, view, boolean) in
            let company = self.companies[indexPath.row]
            print("Attemping to deleting company : \(company.name ?? "")")
            
            // remove the company from tableview
            self.companies.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            // delete the company from coredata
            let context = CoreDataManager.shared.persistentContainer.viewContext
            context.delete(company)
            do{
                try context.save()
            } catch let deleteErr {
                print("Failed to Delete Companies:", deleteErr)
            }
        }
        
        let editItem = UIContextualAction(style: .normal , title: "Edit") { (action, view, boolean) in
            let company = self.companies[indexPath.row]
            print("Attemping to deleting company : \(company.name ?? "")")
        }
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteItem, editItem])
        return swipeActions
    }
    
    /**
     * TableView 2 :  Returing the cell, which will be going to show in the UI for this tableView
     */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let company = companies[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.backgroundColor = .tealColor
        cell.textLabel?.text = company.name
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        return cell
    }
    
    /**
     * TableView 1 :  Returing how many cells wlll be available into tableView
     */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    
    /* TableView Setup End */
    
}
