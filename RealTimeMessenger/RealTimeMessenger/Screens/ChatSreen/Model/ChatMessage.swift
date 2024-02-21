//
//  ChatMessage.swift
//  RealTimeMessenger
//
//  Created by Dmitriy Permyakov on 19.02.2024.
//

import Foundation

struct ChatMessage: Identifiable, Hashable {
    var id = UUID()
    let isYou: Bool
    let message: String
    let userName: String
    let time: String
    let state: Message.State
}

// MARK: - Message

extension Message {

    func mapper(userName: String) -> ChatMessage {
        .init(
            id: id,
            isYou: userName == self.userName,
            message: message,
            userName: userName,
            time: dispatchDate.formattedString(format: "HH:mm"),
            state: state
        )
    }
}
