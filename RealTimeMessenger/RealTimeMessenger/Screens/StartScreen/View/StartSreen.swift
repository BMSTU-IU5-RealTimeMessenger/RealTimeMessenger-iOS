//
//  StartSreen.swift
//  RealTimeMessenger
//
//  Created by Dmitriy Permyakov on 20.02.2024.
//

import SwiftUI

struct StartSreen: View {
    @State private var text = ""
    @StateObject private var nav = Navigation()
    @StateObject private var viewModel = ChatViewModel()

    var body: some View {
        NavigationStack(path: $nav.path) {
            VStack {
                Text("Введите ваш nickName")
                    .font(.title2)

                TextField("nickname", text: $viewModel.userName)
                    .padding(.horizontal)
                    .padding(.vertical, 6)
                    .background(
                        Color.textFieldBackgroundColor,
                        in: .capsule.stroke(lineWidth: 1)
                    )
                    .padding(.horizontal)

                Button {
                    viewModel.connectWebSocket()
                    nav.path.append(text)
                } label: {
                    Text("Начать")
                }
            }
            .navigationDestination(for: String.self) { userName in
                ChatView()
                    .environmentObject(nav)
                    .environmentObject(viewModel)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    StartSreen()
}
