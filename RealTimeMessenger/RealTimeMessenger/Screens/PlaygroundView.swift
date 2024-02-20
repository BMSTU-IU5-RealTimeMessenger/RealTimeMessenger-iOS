//
//  PlaygroundView.swift
//  RealTimeMessenger
//
//  Created by Dmitriy Permyakov on 18.02.2024.
//

import SwiftUI

struct PlaygroundView: View {
    var body: some View {
        VStack {
            Button {
                WebSockerManager.shared.connection()
                WebSockerManager.shared.send(
                    message: Message(
                        kind: .connection,
                        userName: "mightyK1ngRichard",
                        dispatchDate: Date(),
                        message: "подключение пользователя"
                    )
                )
            } label: {
                Text("Подключиться")
            }

            Button {
                WebSockerManager.shared.close()
            } label: {
                Text("OFF")
            }

            Button {
            } label: {
                Text("ОТПРАВИТЬ")
            }
        }
        .padding()
    }
}

// MARK: - Preview

#Preview {
    PlaygroundView()
}
