//
//  WebSocketManager.swift
//  RealTimeMessenger
//
//  Created by Dmitriy Permyakov on 20.02.2024.
//

import Foundation

// MARK: - WebSocketManagerProtocol

protocol WebSocketManagerProtocol: AnyObject {
    func connection(completion: @escaping MRKGenericBlock<Error?>)
    func close()
    func send(message: Message)
    func receive(completion: @escaping MRKGenericBlock<Message>)
}

// MARK: - WebSockerManager

final class WebSockerManager: WebSocketManagerProtocol {
    static let shared = WebSockerManager()
    private var webSocketTask: URLSessionWebSocketTask?
    private let wsPath = "ws://localhost:8080/socket"
    private init() {}

    func connection(completion: @escaping MRKGenericBlock<Error?>) {
        guard let url = URL(string: wsPath) else { return }
        webSocketTask = URLSession(configuration: .default).webSocketTask(with: url)
        webSocketTask?.resume()
        webSocketTask?.sendPing(pongReceiveHandler: completion)
    }

    func close() {
        webSocketTask?.cancel()
        webSocketTask = nil
    }

    func send(message: Message) {
        do {
            let jsonData = try JSONEncoder().encode(message)
            guard let jsonString = String(data: jsonData, encoding: .utf8) else { return }
            let text = URLSessionWebSocketTask.Message.string(jsonString)
            webSocketTask?.send(text) { error in
                if let error {
                    Logger.log(kind: .error, message: error)
                }
            }
        } catch {
            Logger.log(kind: .error, message: error.localizedDescription)
        }
    }

    func receive(completion: @escaping MRKGenericBlock<Message>) {
        webSocketTask?.receive { [weak self] result in
            guard let self, webSocketTask != nil else { return }
            switch result {
            case let .success(enumMessage):
                defer { receive(completion: completion) }

                switch enumMessage {
                case .data: break
                case let .string(stringMessage):
                    Logger.log(message: "Получено сообщение: [ " + stringMessage + " ]")
                    guard let data = stringMessage.data(using: .utf8) else { return }
                    do {
                        let message = try JSONDecoder().decode(Message.self, from: data)
                        completion(message)
                    } catch {
                        Logger.log(
                            kind: .error,
                            message: "Не получилось распарсить сообщение: [ \(stringMessage) ] к типу Message.self.\n [ \(error.localizedDescription) ]"
                        )
                    }
                @unknown default: break
                }

            case let .failure(error):
                Logger.log(kind: .error, message: error.localizedDescription)
            }
        }
    }
}
