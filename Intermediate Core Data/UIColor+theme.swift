//
//  UIColor+theme.swift
//  Intermediate Core Data
//
//  Created by Imtiaz Uddin Ahmed on 2/11/20.
//  Copyright © 2020 Imtiaz. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    static func getColor(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    static let lightRed = getColor(red: 247, green: 66, blue: 82)
    static let darkBlue = getColor(red: 9, green: 45, blue: 64)
    static let tealColor = getColor(red: 48, green: 164, blue: 182)
    static let lightBlue = getColor(red: 218, green: 235, blue: 243)
    static let pupleTest = getColor(red: 101, green: 31, blue: 255)
    
}
