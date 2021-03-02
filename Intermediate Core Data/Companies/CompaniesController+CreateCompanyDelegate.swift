//
//  CompaniesController+CreateCompanyDelegate.swift
//  Intermediate Core Data
//
//  Created by Imtiaz Uddin Ahmed on 23/12/20.
//  Copyright © 2020 Imtiaz. All rights reserved.
//

import UIKit

extension CompaniesController: CreateCompanyControllerDelegate {
    
    func didAddCompany(company: Company) {
        companies.append(company)
        let newIndexPath = IndexPath(row: companies.count - 1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    
    func didEditCompany(company: Company) {
        let row = companies.firstIndex(of: company)
        let reloadIndexPath = IndexPath(row: row!, section: 0)
        tableView.reloadRows(at: [reloadIndexPath], with: .middle)
    }
    
}
