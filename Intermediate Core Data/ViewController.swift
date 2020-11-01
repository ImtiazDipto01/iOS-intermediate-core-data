//
//  ViewController.swift
//  Intermediate Core Data
//
//  Created by Imtiaz Uddin Ahmed on 1/11/20.
//  Copyright © 2020 Imtiaz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus"), style: .plain, target: self, action: #selector(handleAddCompany))
        
        let lightRed = UIColor.getColor(red: 247, green: 66, blue: 82)
        configureNavigationBar(largeTitleColor: .white, backgoundColor: lightRed, tintColor: lightRed, title: "Companies", preferredLargeTitle: true)
    }
    
    
    @objc func handleAddCompany() {
        print("Something going to happen")
    }
    
}


extension UIViewController {
    
    func configureNavigationBar(largeTitleColor: UIColor, backgoundColor: UIColor, tintColor: UIColor, title: String, preferredLargeTitle: Bool) {
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: largeTitleColor]
            navBarAppearance.titleTextAttributes = [.foregroundColor: largeTitleColor]
            navBarAppearance.backgroundColor = backgoundColor

            navigationController?.navigationBar.standardAppearance = navBarAppearance
            navigationController?.navigationBar.compactAppearance = navBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance

            navigationController?.navigationBar.prefersLargeTitles = preferredLargeTitle
            navigationController?.navigationBar.isTranslucent = false
            navigationController?.navigationBar.tintColor = tintColor
            navigationItem.title = title

        } else {
            // Fallback on earlier versions
            navigationController?.navigationBar.isTranslucent = false
            navigationController?.navigationBar.barTintColor = tintColor
            navigationController?.navigationBar.prefersLargeTitles = preferredLargeTitle
            navigationItem.title = title
        }
    }
}


extension UIColor{
    
    static func getColor(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}

