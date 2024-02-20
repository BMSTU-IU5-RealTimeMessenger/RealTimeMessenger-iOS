//
//  ChatViewModel.swift
//  RealTimeMessenger
//
//  Created by Dmitriy Permyakov on 19.02.2024.
//

import Foundation

// MARK: - ChatViewModelProtocol

protocol ChatViewModelProtocol: AnyObject {
    func connectWebSocket()
    func sendMessage(message: String)
}

// MARK: - ChatViewModel

final class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var userName: String = .clear
    private var messagesCount = 0
}

// MARK: - ChatViewModelProtocol

extension ChatViewModel: ChatViewModelProtocol {
    
    /// Create web socket connection with the server
    func connectWebSocket() {
        WebSockerManager.shared.connection()
        WebSockerManager.shared.send(
            message: Message(
                kind: .connection,
                userName: userName,
                dispatchDate: Date(),
                message: .clear
            )
        )
        receiveWebSocketData()
    }
    
    /// Sending message to the server
    /// - Parameter message: message data
    func sendMessage(message: String) {
        WebSockerManager.shared.send(
            message: Message(
                kind: .message,
                userName: userName,
                dispatchDate: Date(),
                message: message
            )
        )
    }
}

// MARK: - Private Methods

private extension ChatViewModel {
    
    /// Getting new message
    func receiveWebSocketData() {
        WebSockerManager.shared.receive { [weak self] message in
            guard let self else { return }
            let chatMessage = ChatMessage(
                id: messagesCount, // FIXME: Может быть сделать ID у message
                isYou: message.userName == userName,
                message: message.message,
                userName: message.userName,
                time: message.dispatchDate.formattedString(format: "HH:mm")
            )
            messagesCount += 1
            DispatchQueue.main.async {
                self.messages.append(chatMessage)
            }
        }
    }
}
