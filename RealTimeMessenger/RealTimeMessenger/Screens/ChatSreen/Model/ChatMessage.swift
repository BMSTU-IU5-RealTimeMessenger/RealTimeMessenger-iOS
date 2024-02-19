//
//  ChatMessage.swift
//  RealTimeMessenger
//
//  Created by Dmitriy Permyakov on 19.02.2024.
//

import Foundation

struct ChatMessage {
    let id: Int
    let isYou: Bool
    let message: String
    let userName: String
    let time: String
}
