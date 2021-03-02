//
//  UIViewController+Utils.swift
//  Intermediate Core Data
//
//  Created by Imtiaz Uddin Ahmed on 30/12/20.
//  Copyright © 2020 Imtiaz. All rights reserved.
//

import UIKit

extension UIViewController {
    
    /**
     * Here, we're configuring navigationBar
     * Tip: Before configuring navigation bar, Please setup the Navigation Controller into [SceneDelegate]
     */
    func setUpNavigationBar(largeTitleColor: UIColor, backgoundColor: UIColor, tintColor: UIColor, title: String, preferredLargeTitle: Bool) {
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
    
    
    func setUpCancleButtonIntoNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancle", style: .plain, target: self, action: #selector(handleCancle))
    }
    
    @objc func handleCancle() {
        dismiss(animated: true, completion: nil)
    }
}
