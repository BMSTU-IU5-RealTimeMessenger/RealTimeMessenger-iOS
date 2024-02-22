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
    var kind: Kind = .bubble

    enum Kind {
        case bubble
        case join
        case quit
    }
}

// MARK: - Message

extension Message {

    func mapper(name: String) -> ChatMessage {
        .init(
            id: id,
            isYou: userName == name,
            message: message,
            userName: userName,
            time: dispatchDate.formattedString(format: "HH:mm"),
            state: state,
            kind: kind.toChatKind
        )
    }
}

private extension Message.MessageKind {

    var toChatKind: ChatMessage.Kind {
        switch self {
        case .connection: return .join
        case .message: return .bubble
        case .close: return .quit
        }
    }
}
