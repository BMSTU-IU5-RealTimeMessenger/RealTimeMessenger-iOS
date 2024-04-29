//
//  ChatViewModel.swift
//  RealTimeMessenger
//
//  Created by Dmitriy Permyakov on 19.02.2024.
//

import Foundation

// MARK: - ChatViewModelProtocol

protocol ChatViewModelProtocol: AnyObject {
    func connectWebSocket(completion: MRKGenericBlock<APIError?>?)
    func sendMessage(message: String)
    func didTapSignIn(userName: String, completion: @escaping MRKGenericBlock<APIError?>)
}

// MARK: - ChatViewModel

final class ChatViewModel: ObservableObject {
    @Published private(set) var messages: [ChatMessage] = []
    @Published private(set) var lastMessageID: UUID?
    @Published private(set) var userName: String = .clear
}

// MARK: - ChatViewModelProtocol

extension ChatViewModel: ChatViewModelProtocol {
    
    /// Create web socket connection with the server
    func connectWebSocket(completion: MRKGenericBlock<APIError?>? = nil) {
        let mainQueueCompletion: MRKGenericBlock<APIError?> = { error in
            DispatchQueue.main.async {
                completion?(error)
            }
        }

        WebSockerManager.shared.connection { [weak self] error in
            guard let self else { return }
            if let error {
                mainQueueCompletion(.error(error))
                return
            }
            mainQueueCompletion(nil)
            WebSockerManager.shared.send(
                message: Message(
                    id: UUID(),
                    kind: .connection,
                    userName: userName,
                    dispatchDate: Date(),
                    message: .clear
                )
            )
            receiveWebSocketData()
        }
    }
    
    /// Sending message to the server
    func sendMessage(message: String) {
        let msg = Message(
            id: UUID(),
            kind: .message,
            userName: userName,
            dispatchDate: Date(),
            message: message
        )
        lastMessageID = msg.id
        messages.append(msg.mapper(name: userName))
        WebSockerManager.shared.send(message: msg)
    }
    
    /// Quit chat view
    func quitChat() {
        messages = []
        lastMessageID = nil
        userName = .clear
        WebSockerManager.shared.close()
    }
    
    /// Did tap sign in button
    func didTapSignIn(userName: String, completion: @escaping MRKGenericBlock<APIError?>) {
        self.userName = userName
        connectWebSocket(completion: completion)
    }
}

// MARK: - Private Methods

private extension ChatViewModel {
    
    /// Getting new message
    func receiveWebSocketData() {
        WebSockerManager.shared.receive { [weak self] message in
            guard let self else { return }
            let chatMessage = message.mapper(name: userName)
            // Если сообщение не найденно, значит добавляем его
            guard !messages.contains(where: { $0.id == chatMessage.id }) else { return }
            DispatchQueue.main.async {
                self.messages.append(chatMessage)
                self.lastMessageID = chatMessage.id
            }
        }
    }
}

// MARK: - Reducers

#if DEBUG
extension ChatViewModel {

    func setPreviewData(name: String, messages: [ChatMessage] = .mockData, lastMessage: UUID? = nil) {
        self.userName = name
        self.messages = messages
        self.lastMessageID = lastMessage
    }
}
#endif
