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
    func didEditCompany(company: Company)
}


/**
 * Implementing [UINavigationControllerDelegate] and [UIImagePickerControllerDelegate] for getting Selected Image from Image Picker
 */
class CreateCompanyController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // MARK: -  Local Variables
    var createCompanyDelegate: CreateCompanyControllerDelegate?
    var company: Company?{
        didSet{
            nameTextField.text = company?.name
            
            if let companyImg = company?.imageData {
                companyImageView.image = UIImage(data: companyImg)
            }
            
            guard let founded = company?.founded else { return }
            datePicker.date = founded
        }
    }
    
        
    // MARK: -  UI Element Start
    lazy var companyImageView: UIImageView = {
       
        // Remember : Add photo library usage permission
        
        let imageView = UIImageView(image: #imageLiteral(resourceName: "select_photo_empty"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true // remember to do this, other wise image views by default are not interactive
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectPhoto)))
        
        imageView.layer.cornerRadius = imageView.frame.width / 2
        imageView.layer.borderColor = UIColor.darkBlue.cgColor
        imageView.layer.borderWidth = 2
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
        
    }()
    
    let nameLabel: UILabel = {
       
        let label = UILabel()
        label.text = "Name"
        label.translatesAutoresizingMaskIntoConstraints = false //enable autolayout
        return label
        
    }()
    
    let nameTextField: UITextField = {
        
        let textLabel = UITextField()
        textLabel.placeholder = "Enter Name"
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        return textLabel
        
    }()
    
    let datePicker: UIDatePicker = {
        
        let dp = UIDatePicker()
        dp.translatesAutoresizingMaskIntoConstraints = false
        dp.datePickerMode = .date
        return dp
        
    }()
    
    
    // MARK: -  LifeCycle and Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = company == nil ? "Add Company" : "Edit Company"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancle", style: .plain, target: self, action: #selector(handleCancle))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
        
        configureNavigationBar(largeTitleColor: .white, backgoundColor: .lightRed, tintColor: .white, title: "Create Company", preferredLargeTitle: true)
        
        view.backgroundColor = .darkBlue
        
        setupUI()
    }
    
    private func setUpCircularImageView() {
        companyImageView.layer.cornerRadius = companyImageView.frame.width / 2
        companyImageView.layer.borderColor = UIColor.darkBlue.cgColor
        companyImageView.layer.borderWidth = 2
        companyImageView.clipsToBounds = true
    }
    
    @objc func handleCancle() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleSave() {
        company == nil ? createCompany() : saveCompanyChanges()
    }
    
    @objc func handleSelectPhoto() {
        print("Photo selection wwill happen here...")
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.modalPresentationStyle = .fullScreen
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let originalEditedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            companyImageView.image = originalEditedImage
        }
        else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            companyImageView.image = originalImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    private func saveCompanyChanges() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        company?.name = nameTextField.text
        company?.founded = datePicker.date
        
        if let companyImage = companyImageView.image {
            let imageData = companyImage.jpegData(compressionQuality: 0.8)
            company?.imageData = imageData
        }
        
        do{
            try context.save()
            dismiss(animated: true) {
                self.createCompanyDelegate?.didEditCompany(company: self.company!)
            }
            
        } catch let saveErr {
            print("Failed to Save Company", saveErr)
        }
    }
    
    private func createCompany() {
        print("Saving a compnay..")
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let company = NSEntityDescription.insertNewObject(forEntityName: "Company", into: context)
        
        company.setValue(nameTextField.text, forKey: "name")
        company.setValue(datePicker.date, forKey: "founded")
        
        if let companyImage = companyImageView.image {
            let imageData = companyImage.jpegData(compressionQuality: 0.8)
            company.setValue(imageData, forKey: "imageData")
        }
        
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
        lightBlueBackgroundView.heightAnchor.constraint(equalToConstant: 350).isActive = true
        
        view.addSubview(companyImageView)
        companyImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        companyImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        companyImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        companyImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: companyImageView.bottomAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(nameTextField)
        nameTextField.leftAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        nameTextField.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive = true
        
        view.addSubview(datePicker)
        datePicker.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        datePicker.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        datePicker.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        datePicker.bottomAnchor.constraint(equalTo: lightBlueBackgroundView.bottomAnchor).isActive = true
        
    }
}
