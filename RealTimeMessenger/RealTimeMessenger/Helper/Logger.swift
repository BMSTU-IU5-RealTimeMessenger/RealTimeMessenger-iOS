//
//  Logger.swift
//  RealTimeMessenger
//
//  Created by Dmitriy Permyakov on 20.02.2024.
//

import Foundation

final class Logger {
    private init() {}

    static func log(kind: Kind = .info, message: Any, function: String = #function) {
        print("[ \(kind.rawValue.uppercased()) ]: [ \(Date()) ]: [ \(function) ]")
        print(message)
        print()
    }

    enum Kind: String, Hashable {
        case info
        case error
        case warning
    }
}
