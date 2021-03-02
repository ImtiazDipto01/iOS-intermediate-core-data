//
//  CompaniesController+UITableView.swift
//  Intermediate Core Data
//
//  Created by Imtiaz Uddin Ahmed on 23/12/20.
//  Copyright © 2020 Imtiaz. All rights reserved.
//

import UIKit

extension CompaniesController {
    
    private func editItem(indexPath: IndexPath, action: UIContextualAction, view: UIView) {
        let company = self.companies[indexPath.row]
        print("Attemping to Editing company : \(company.name ?? "")")
        
        let createCompanyController = CreateCompanyController()
        createCompanyController.company = company
        createCompanyController.createCompanyDelegate = self
        
        let navController = CustomNavigationController(rootViewController: createCompanyController)
        navController.modalPresentationStyle = .fullScreen
        
        present(navController, animated: true, completion: nil)
    }
    
    
    /* TableView Setup Start */
    
    /**
     * Returning a UIView, if you need a footer in table view for showing "No data available" type message
     */
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "No companies available..."
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }
    
    /**
     * Returning CGFloat value, for specifing a height of the footer.
     */
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return companies.count == 0 ? 150 : 0
    }
    
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
        deleteItem.backgroundColor = .lightRed
        
        let edit = UIContextualAction(style: .normal , title: "Edit") { (action, view, boolean) in
            self.editItem(indexPath: indexPath, action: action, view: view)
        }
        edit.backgroundColor = .darkBlue
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteItem, edit])
        return swipeActions
    }
    
    
    /**
    * Returning CGFloat value, for specifing a height of the Row.
    */
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    /**
     * If any of row clicked from the tableview, this method will call
     * Here, we're pushing a new viewcontroller after clicking a companies item.
     */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let company = companies[indexPath.row]
        let employessViewController = EmployessVC()
        employessViewController.company = company
        navigationController?.pushViewController(employessViewController, animated: true)
    }
    
    /**
     * TableView 2 :  Returing the cell, which will be going to show in the UI for this tableView
     */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let company = companies[indexPath.row]
        
        // text label showing here
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! CompanyCell
        cell.company = company
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
