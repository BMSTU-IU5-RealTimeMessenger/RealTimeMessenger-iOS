//
//  UIColor+Extenstions.swift
//  RealTimeMessenger
//
//  Created by Dmitriy Permyakov on 25/10/2023.
//

import UIKit

extension UIColor {

    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0xFF00) >> 8) / 255.0
        let blue = CGFloat(hex & 0xFF) / 255.0
        self.init(displayP3Red: red, green: green, blue: blue, alpha: alpha)
    }
}
