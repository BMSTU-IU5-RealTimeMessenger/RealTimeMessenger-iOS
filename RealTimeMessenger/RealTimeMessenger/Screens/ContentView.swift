//
//  ContentView.swift
//  RealTimeMessenger
//
//  Created by Dmitriy Permyakov on 18.02.2024.
//

import SwiftUI

struct Message: Codable {
    let id: Int
    let event: String
    let message: String
    let userName: String
}

final class Logger {
    static let logger = Logger()
    private init() {}

    func error(error: Error, function: String = #function) {
        print("----------- ERROR ------------")
        print(function)
        print()
        print("-------- ERROR MESSAGE -------")
        print(error.localizedDescription)
        print("------------------------------")
    }
}

final class WebSockerManager {
    static let shared = WebSockerManager()
    private var webSocketTask: URLSessionWebSocketTask?

    private init() {}

    func on() {
        guard webSocketTask == nil else { return }
        guard let url = URL(string: "ws://localhost:8080/socket") else { return }
        webSocketTask = URLSession(configuration: .default).webSocketTask(with: url)
        webSocketTask?.resume()
        receive()
    }

    func off() {
        webSocketTask?.cancel()
        webSocketTask = nil
    }

    func send(message: Message) {
        do {
            let jsonData = try JSONEncoder().encode(message)
            guard let jsonString = String(data: jsonData, encoding: .utf8) else { return }
            let text = URLSessionWebSocketTask.Message.string(jsonString)
            webSocketTask?.send(text) { error in
                if let error = error {
                    print("WebSocket send error: \(error)")
                }
            }
        } catch {
            Logger.logger.error(error: error)
        }
    }

    func receive() {
        webSocketTask?.receive { [weak self] result in
            guard let self else { return }

            switch result {
            case let .success(enumMessage):
                defer { receive() }
                switch enumMessage {
                case .data: break

                case let .string(stringMessage):
                    print(stringMessage)
                    guard let data = stringMessage.data(using: .utf8) else { return }
                    if let message = try? JSONDecoder().decode(Message.self, from: data) {
                        print(message)
                    }

                @unknown default: break
                }
            case let .failure(error):
                Logger.logger.error(error: error)
            }
        }
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            Button {
                WebSockerManager.shared.on()
                WebSockerManager.shared.send(
                    message: Message(
                        id: 1,
                        event: "connection",
                        message: "Я тут", 
                        userName: "MightyK1ngRichard"
                    )
                )
            } label: {
                Text("Подключиться")
            }

            Button {
                WebSockerManager.shared.off()
            } label: {
                Text("OFF")
            }

            Button {
                let message = Message(
                    id: 1,
                    event: "message",
                    message: "Текст сообщения",
                    userName: "MightyK1ngRichard"
                )
                WebSockerManager.shared.send(message: message)
            } label: {
                Text("ОТПРАВИТЬ")
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
