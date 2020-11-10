//
//  CreateCompanyController.swift
//  Intermediate Core Data
//
//  Created by Imtiaz Uddin Ahmed on 8/11/20.
//  Copyright © 2020 Imtiaz. All rights reserved.
//

import UIKit
class CreateCompanyController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancle", style: .plain, target: self, action: #selector(handleCancle))
        configureNavigationBar(largeTitleColor: .white, backgoundColor: .lightRed, tintColor: .white, title: "Create Company", preferredLargeTitle: true)
        
        view.backgroundColor = .darkBlue
    }
    
    @objc func handleCancle() {
        dismiss(animated: true, completion: nil)
    }
}
