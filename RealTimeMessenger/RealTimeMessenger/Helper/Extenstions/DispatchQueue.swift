//
//  DispatchQueue.swift
//  RealTimeMessenger
//
//  Created by Dmitriy Permyakov on 21.02.2024.
//

import Foundation

func asyncMain(completion: @escaping () -> Void) {
    DispatchQueue.main.async(execute: completion)
}
