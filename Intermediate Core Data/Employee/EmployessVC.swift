//
//  EmployessViewController.swift
//  Intermediate Core Data
//
//  Created by Imtiaz Uddin Ahmed on 1/1/21.
//  Copyright © 2021 Imtiaz. All rights reserved.
//

import UIKit

class IndentedLabel: UILabel {
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        super.drawText(in: rect.inset(by: insets))
    }
}

class EmployessVC: UITableViewController, CreateEmployeeDelegate {
    
    func didAddEmployee(employee: Employee) {
        employees.append(employee)
        tableView.reloadData() 
    }
    
    
    let employeeCellId = "employeeCellId"
    
    var company: Company?
    var employees = [Employee]()
    
    
    // MARK: -  LifeCycle and Methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = company?.name
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableViewUi()
        fetchEmployees()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus"), style: .plain, target: self, action: #selector(handleAddEmploye))
    }
    
     
    private func fetchEmployees() {
        print("fetching companies..")
        guard let companyEmployees = company?.employees?.allObjects as? [Employee] else { return }
        self.employees = companyEmployees
    }
    
    /**
     * here, we're  opening a Add Employee viewcontroller
     */
    @objc private func handleAddEmploye() {
        let createEmployeeController = CreateEmployeeVC()
        createEmployeeController.delegate = self
        createEmployeeController.company = company
           
        let navController = CustomNavigationController(rootViewController: createEmployeeController)
        navController.modalPresentationStyle = .fullScreen
           
        present(navController, animated: true, completion: nil)
    }
    
    /**
     * setting some basic stuff for tableView
     */
    private func setupTableViewUi() {
        tableView.backgroundColor = .darkBlue
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: employeeCellId)
    }
    
    
    /* TableView Setup Start */
    
    /**
     * In this method we return how many section sohuld visiable in our tableview
     */
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    /**
     * Returning a UIView, If you need a header of your each section
     */
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = IndentedLabel()
        label.text = "HEADER"
        label.backgroundColor = UIColor.lightBlue
        label.textColor = .darkBlue
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }
        
    /**
     * Returning CGFloat value, for specifing a height of the header.
     */
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    /**
     * TableView 2 :  Returing the cell, which will be going to show in the UI for this tableView
     */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let employee = employees[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: employeeCellId, for: indexPath)
    
        // text label showing here
        cell.textLabel?.text = employee.name
        
        if let birthDayDate = employee.employeeInformation?.birthday {
            let dateFormater = DateFormatter()
            dateFormater.dateFormat = "MMM dd, yyyy"
            cell.textLabel?.text = "\(employee.name ?? "") \(dateFormater.string(from: birthDayDate))"
        }
        
        cell.backgroundColor = .tealColor
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        return cell
    }
    
    /**
     * TableView 1 :  Returing how many cells wlll be available into tableView
     */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }
    
    /* TableView Setup End */
}
