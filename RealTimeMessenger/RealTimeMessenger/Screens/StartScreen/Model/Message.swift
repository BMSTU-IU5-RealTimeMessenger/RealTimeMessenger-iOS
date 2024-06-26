//
//  Message.swift
//  RealTimeMessenger
//
//  Created by Dmitriy Permyakov on 20.02.2024.
//

import Foundation

struct Message: Codable, Identifiable {
    var id: String
    let kind: MessageKind
    let userName: String
    let dispatchDate: Date
    let message: String

    enum MessageKind: String, Codable {
        case connection
        case message
        case close
        case error
    }
}
