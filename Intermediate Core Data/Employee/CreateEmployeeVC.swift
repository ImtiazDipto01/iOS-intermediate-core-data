//
//  CreateEmployeeViewController.swift
//  Intermediate Core Data
//
//  Created by Imtiaz Uddin Ahmed on 1/1/21.
//  Copyright © 2021 Imtiaz. All rights reserved.
//

import UIKit


// MARK: -  Custom Delegation
protocol CreateEmployeeDelegate {
    func didAddEmployee(employee: Employee)
    //func didEditCompany(company: Company)
}


class CreateEmployeeVC: UIViewController {
    
    // MARK: -  UI elements
    let lightBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightBlue
        return view
    }()
    
    let employeeNameLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Name"
        return label
        
    }()
    
    let employeeNameTextField: UITextField = {
        
        let textLabel = UITextField()
        textLabel.placeholder = "Enter Name"
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        return textLabel
        
    }()
    
    let employeeBirthdayLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Birthday"
        return label
        
    }()
    
    let employeeBirthdayTextField: UITextField = {
        
        let textLabel = UITextField()
        textLabel.placeholder = "MM/dd/yyyy"
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        return textLabel
        
    }()
    
    
    let employeeTypeSegmentControl: UISegmentedControl =  {
        let types = [
            EmployeeType.Executive.rawValue,
            EmployeeType.SeniorManager.rawValue,
            EmployeeType.Staff.rawValue
        ]
        let sc = UISegmentedControl(items: types)
        sc.selectedSegmentIndex = 0
        sc.tintColor = UIColor.darkBlue
        return sc
        
    }()
    
    
    // MARK: -  Local Variables
    var delegate: CreateEmployeeDelegate?
    var company: Company?
    
    
    // MARK: -  LifeCycle and other methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .darkBlue
        
        setUpCancleButtonIntoNavigationBar()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
        setUpNavigationBar(largeTitleColor: .white, backgoundColor: .lightRed, tintColor: .white, title: "Create Employee", preferredLargeTitle:true)
        
        setupUI()
    }
    
    
    @objc private func handleSave() {
        guard let employeeName = employeeNameTextField.text else { return }
        guard let company = self.company else { return }
        guard let date = employeeBirthdayTextField.text else { return }
        
        
        if(isCreateEmployeeValidationSucess(employeeName: employeeName, birthDayDate: date)) {
            let birthDayDate = getBirthDayDate(date: date)
            
            guard let employeeType = employeeTypeSegmentControl.titleForSegment(at: employeeTypeSegmentControl.selectedSegmentIndex) else {
                return
            }
            
            let tuple = CoreDataManager.shared.createEmployee(name: employeeName, birthDayDate: birthDayDate!, type: employeeType, company: company)
            
            if let err = tuple.1 {
                print(err)
            } else {
                dismiss(animated: true, completion: {
                    self.delegate?.didAddEmployee(employee: tuple.0!)
                })
            }
        }
    }
    
    
    private func getBirthDayDate(date: String) -> Date? {
        
        let dateformater = DateFormatter()
        dateformater.dateFormat = "MM/dd/yyyy"
        
        return dateformater.date(from: date)
    }
    
    
    private func isBadBirthDayFormat(birthDayDate: String) -> Bool {
        let dateformater = DateFormatter()
        dateformater.dateFormat = "MM/dd/yyyy"
        
        guard let _ = dateformater.date(from: birthDayDate) else {
            return true
        }
        return false
    }
    
    
    private func isCreateEmployeeValidationSucess(employeeName: String, birthDayDate: String) -> Bool {
        if employeeName.isEmpty {
            showAlert(title: "Empty Employee Name", message: "Employee Name Can not be empty")
            return false
        }
        else if birthDayDate.isEmpty {
            showAlert(title: "Empty Birth Day Date", message: "Birth Day Date Can not be empty")
            return false
        }
        else if isBadBirthDayFormat(birthDayDate: birthDayDate) {
            showAlert(title: "Bad Birthday Format", message: "Please Check Birthday Format")
            return false
        }
        else {
            return true
        }
    }
    
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
     
    private func setupUI() {
        view.addSubview(lightBackgroundView)
        lightBackgroundView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 150)
        
        lightBackgroundView.addSubview(employeeNameLabel)
        employeeNameLabel.anchor(top: lightBackgroundView.topAnchor, left: lightBackgroundView.leftAnchor, paddingLeft: 16, width: 100, height: 50)
        
        lightBackgroundView.addSubview(employeeNameTextField)
        employeeNameTextField.anchor(top: lightBackgroundView.topAnchor, left: employeeNameLabel.rightAnchor, bottom: employeeNameLabel.bottomAnchor, right: view.rightAnchor)
        
        lightBackgroundView.addSubview(employeeBirthdayLabel)
        employeeBirthdayLabel.anchor(top: employeeNameLabel.bottomAnchor, left: lightBackgroundView.leftAnchor, paddingLeft: 16, width: 100, height: 50)
        
        lightBackgroundView.addSubview(employeeBirthdayTextField)
        employeeBirthdayTextField.anchor(top: employeeNameTextField.bottomAnchor, left: employeeBirthdayLabel.rightAnchor, bottom: employeeBirthdayLabel.bottomAnchor, right: lightBackgroundView.rightAnchor)
        
        lightBackgroundView.addSubview(employeeTypeSegmentControl)
        employeeTypeSegmentControl.anchor(top: employeeBirthdayLabel.bottomAnchor, left: lightBackgroundView.leftAnchor, right: lightBackgroundView.rightAnchor, paddingTop: 0, paddingLeft: 16,  paddingRight: 16, height: 34)
        
    }
}
