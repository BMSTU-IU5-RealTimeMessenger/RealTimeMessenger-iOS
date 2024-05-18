//
//  MKRColor.swift
//  RealTimeMessenger
//
//  Created by Dmitriy Permyakov on 20.02.2024.
//

import SwiftUI

final class MKRColor<Palette: Hashable> {
    let color: Color
    let uiColor: UIColor

    init(hexLight: Int, hexDark: Int, alphaLight: CGFloat = 1.0, alphaDark: CGFloat = 1.0) {
        let lightColor = UIColor(hex: hexLight, alpha: alphaLight)
        let darkColor = UIColor(hex: hexDark, alpha: alphaDark)
        let uiColor = UIColor { $0.userInterfaceStyle == .light ? lightColor : darkColor }
        self.uiColor = uiColor
        self.color = Color(uiColor: uiColor)
    }

    init(hexLight: Int, hexDark: Int, alpha: CGFloat = 1.0) {
        let chmColor = MKRColor(hexLight: hexLight, hexDark: hexDark, alphaLight: alpha, alphaDark: alpha)
        self.uiColor = chmColor.uiColor
        self.color = chmColor.color
    }

    init(uiColor: UIColor) {
        self.uiColor = uiColor
        self.color = Color(uiColor: uiColor)
    }
}

// MARK: - Palettes

enum TextPalette: Hashable {}
enum BackgroundPalette: Hashable {}
enum SeparatorPalette: Hashable {}

// MARK: - BackgroundPalette

extension MKRColor where Palette == BackgroundPalette {

    static let messageBackgroundColor = Color(red: 103/255, green: 77/255, blue: 122/255)
    static let textFieldBackgroundColor = Color(red: 6/255, green: 6/255, blue: 6/255)
    static let bottomBackgroundColor = Color(red: 28/255, green: 28/255, blue: 29/255)
    /// Черный белый фон
    static let bgPrimary = MKRColor(hexLight: 0xF9F9F9, hexDark: 0x060606)
    static let bgInfo = MKRColor(hexLight: 0xE9E9E9, hexDark: 0x000000)
    /// Черный с серым
    static let bgSecondary = MKRColor(hexLight: 0xE7E7E7, hexDark: 0x060606)
}

// MARK: - TextPalette

extension MKRColor where Palette == TextPalette {

    /// Основной текст
    static let textPrimary = MKRColor(hexLight: 0x222222, hexDark: 0xF6F6F6)
    static let textWhite = MKRColor(uiColor: .white)
}

// MARK: - SeparatorPalette

extension MKRColor where Palette == SeparatorPalette {

    static let textFieldStrokeColor = MKRColor<SeparatorPalette>(hexLight: 0xD1D1D1, hexDark: 0x3A3A3C)
}
