//
//  ViewController.swift
//  Intermediate Core Data
//
//  Created by Imtiaz Uddin Ahmed on 1/11/20.
//  Copyright © 2020 Imtiaz. All rights reserved.
//

import UIKit

class CompaniesController: UITableViewController {
    
    let companies = [
        Company(name: "Facebook", date: Date()),
        Company(name: "Google", date: Date()),
        Company(name: "Apple", date: Date()),
        Company(name: "Amazon", date: Date()),
        Company(name: "Alibaba", date: Date())
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
        
        // setting some basic stuff for tableView
        tableView.backgroundColor = .darkBlue
        //tableView.separatorStyle = .none
        tableView.separatorColor = .white
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        
        // setting up Navigation Bar and Bar Item
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus"), style: .plain, target: self, action: #selector(handleAddCompany))
        configureNavigationBar(largeTitleColor: .white, backgoundColor: .lightRed, tintColor: .lightRed, title: "Companies", preferredLargeTitle: true)
    }
    
    
    @objc func handleAddCompany() {
        
        let createCompanyController = CreateCompanyController()
        
        let navController = CustomNavigationController(rootViewController: createCompanyController)
        navController.modalPresentationStyle = .fullScreen
        
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
