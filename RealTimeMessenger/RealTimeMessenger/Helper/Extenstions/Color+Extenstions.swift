//
//  Color+Extenstions.swift
//  RealTimeMessenger
//
//  Created by Dmitriy Permyakov on 20.02.2024.
//

import SwiftUI

extension Color {

    static let messageBackgroundColor = Color(red: 103/255, green: 77/255, blue: 122/255)
    static let textFieldBackgroundColor = Color(red: 6/255, green: 6/255, blue: 6/255)
    static let textFieldStrokeColor = Color(red: 58/255, green: 58/255, blue: 60/255)
    static let bottomBackgroundColor = Color(red: 28/255, green: 28/255, blue: 29/255)
}

extension Color {
    
    init(hex: Int, alpha: Double = 1.0) {
        let red = Double((hex & 0xFF0000) >> 16) / 255.0
        let green = Double((hex & 0x00FF00) >> 8) / 255.0
        let blue = Double(hex & 0x0000FF) / 255.0

        self.init(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
    }
}
