//
//  ChatView.swift
//  RealTimeMessenger
//
//  Created by Dmitriy Permyakov on 19.02.2024.
//

import SwiftUI

struct ChatView: View {
    @Environment(ChatViewModel.self) var viewModel
    @State var messageText: String = .clear
    @FocusState var isInputing: Bool

    var body: some View {
        MainView
            .onDisappear(perform: viewModel.quitChat)
    }
}

// MARK: - Actions

extension ChatView {

    func didTapSendMessage() {
        guard !messageText.isEmpty else { return }
        viewModel.sendMessage(message: messageText)
        messageText = .clear
    }
}

// MARK: - Preview

#Preview {
    ChatView()
        .environment(ChatViewModel.mockData)
}
