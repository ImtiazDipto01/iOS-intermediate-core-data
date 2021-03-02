//
//  CompanyCell.swift
//  Intermediate Core Data
//
//  Created by Imtiaz Uddin Ahmed on 14/12/20.
//  Copyright © 2020 Imtiaz. All rights reserved.
//

import Foundation
import UIKit

class CompanyCell: UITableViewCell {
    
    var company: Company? {
        didSet {
            nameDateLabel.text = company?.name
            
            if let name = company?.name, let founded = company?.founded {
                
                let dateFormater = DateFormatter()
                dateFormater.dateFormat = "MMM dd, yyyy"
                let foundedDateString = dateFormater.string(from: founded)
                
                let dateString = "\(name) - Founded: \(foundedDateString)"
                nameDateLabel.text = dateString
            }
            else {
                nameDateLabel.text = company?.name
            }
            
            if let imgData = company?.imageData {
                companyImageView.image = UIImage(data: imgData)
            }
        }
    }
    
    let companyImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "select_photo_empty"))
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.darkBlue.cgColor
        imageView.layer.borderWidth = 1
        return imageView
    }()
    
    let nameDateLabel: UILabel = {
        let label = UILabel()
        label.text = "COMPANY NAME"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.tealColor
        
        addSubview(companyImageView)
        companyImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        companyImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        companyImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        companyImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(nameDateLabel)
        nameDateLabel.leftAnchor.constraint(equalTo: companyImageView.rightAnchor, constant: 8).isActive = true
        nameDateLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        nameDateLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
