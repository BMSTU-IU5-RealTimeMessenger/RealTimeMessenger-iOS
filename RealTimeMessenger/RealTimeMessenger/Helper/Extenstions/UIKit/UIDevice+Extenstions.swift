//
//  UIDevice+Extenstions.swift
//  RealTimeMessenger
//
//  Created by Dmitriy Permyakov on 22.02.2024.
//

import UIKit

extension UIDevice {

    static var isSe: Bool {
        UIDevice.current.name == "iPhone SE (3rd generation)"
    }

    static var isIpad: Bool {
        UIDevice.current.model == "iPad"
    }
}
