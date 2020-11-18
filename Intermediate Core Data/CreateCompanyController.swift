//
//  CreateCompanyController.swift
//  Intermediate Core Data
//
//  Created by Imtiaz Uddin Ahmed on 8/11/20.
//  Copyright © 2020 Imtiaz. All rights reserved.
//

import UIKit
import CoreData


// MARK: -  Custom Delegation
protocol CreateCompanyControllerDelegate {
    func didAddCompany(company: Company)
}


class CreateCompanyController: UIViewController {
    
    var createCompanyDelegate: CreateCompanyControllerDelegate?
    
    let nameLabel: UILabel = {
       
        let label = UILabel()
        label.text = "Name"
        
        //enable autolayout
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    let nameTextField: UITextField = {
        
        let textLabel = UITextField()
        textLabel.placeholder = "Enter Name"
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        return textLabel
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancle", style: .plain, target: self, action: #selector(handleCancle))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
        
        configureNavigationBar(largeTitleColor: .white, backgoundColor: .lightRed, tintColor: .white, title: "Create Company", preferredLargeTitle: true)
        
        view.backgroundColor = .darkBlue
        
        setupUI()
    }
    
    @objc func handleCancle() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleSave() {
        print("Saving a compnay..")
        
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let company = NSEntityDescription.insertNewObject(forEntityName: "Company", into: context)
        company.setValue(nameTextField.text, forKey: "name")
        
        
        // perform the save operation
        do{
            try context.save()
            
            // success
            dismiss(animated: true) {
                self.createCompanyDelegate?.didAddCompany(company: company as! Company)
            }
            
        } catch let saveErr {
            print("Failed to Save Company", saveErr)
        }
        
    }
    
    func setupUI(){
        
        let lightBlueBackgroundView = UIView()
        lightBlueBackgroundView.backgroundColor = .lightBlue
        lightBlueBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lightBlueBackgroundView)
        lightBlueBackgroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        lightBlueBackgroundView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        lightBlueBackgroundView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        lightBlueBackgroundView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        view.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(nameTextField)
        nameTextField.leftAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        nameTextField.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive = true
        
    }
}
