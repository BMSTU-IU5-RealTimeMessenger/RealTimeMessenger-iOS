//
//  ChatView.swift
//  RealTimeMessenger
//
//  Created by Dmitriy Permyakov on 19.02.2024.
//

import SwiftUI

struct ChatView: View {
    @EnvironmentObject var viewModel: ChatViewModel
    @State private var messageText: String = .clear

    var body: some View {
        ScrollViewReader { proxy in
            ZStack(alignment: .bottom) {
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.messages) { message in
                            MessageBlockView(message: message)
                        }
                    }
                    .padding(.bottom, 50)
                }
                .onTapGesture {
                    UIApplication.shared.sendAction(
                        #selector(UIResponder.resignFirstResponder),
                        to: nil,
                        from: nil,
                        for: nil
                    )
                }

                TextFieldBlock
                    .padding(.vertical, 6)
                    .background(.ultraThinMaterial)
            }
            .onChange(of: viewModel.lastMessageID) { _, id in
                if let id {
                    withAnimation {
                        proxy.scrollTo(id, anchor: .bottom)
                    }
                }
            }
            .background {
                BackgroundView
                    .ignoresSafeArea()
            }
        }
        .onDisappear(perform: viewModel.quitChat)
    }
}

// MARK: - UI Subviews

private extension ChatView {

    @ViewBuilder
    func MessageBlockView(message: ChatMessage) -> some View {
        switch message.kind {
        case .bubble:
            MessageBubble(message: message)
                .padding(.horizontal, 8)

        case .join:
            MessageJoinText(
                text: Constants.joinChatMessage(userName: message.userName)
            )

        case .quit:
            MessageJoinText(
                text: Constants.quitChatMessage(userName: message.userName)
            )

        case .error:
            MessageJoinText(text: "Ошибка отправки сообщения")
        }
    }

    var BackgroundView: some View {
        LinearGradient(
            colors: Constants.gradientBackgroundColor,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .mask {
            Constants.tgBackground
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    var TextFieldBlock: some View {
        HStack {
            Image.paperClip

            TextField(Constants.placeholder, text: $messageText)
                .padding(.vertical, 6)
                .padding(.horizontal, 13)
                .background(Constants.textFieldBackgroundColor, in: .rect(cornerRadius: 20))
                .overlay {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(lineWidth: 1)
                        .fill(Constants.textFieldStrokeColor)
                }

            if messageText.isEmpty {
                Image.record
                    .frame(width: 22, height: 22)
                
            } else {
                Button {
                    viewModel.sendMessage(message: messageText)
                    messageText = .clear
                } label: {
                    Image(systemName: Constants.paperplane)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 22, height: 22)
                        .foregroundStyle(Constants.iconColor)
                }
            }
        }
        .padding(.horizontal, 8)
    }

    func MessageJoinText(text: String) -> some View {
        Text(text)
            .font(.caption)
            .padding(.horizontal)
            .padding(.vertical, 6)
            .background(.black.opacity(0.7), in: .capsule)
            .multilineTextAlignment(.center)
            .padding(.horizontal)
    }
}

// MARK: - Preview

#Preview {
    let viewModel = ChatViewModel()
    viewModel.connectWebSocket { _ in 
        viewModel.setPreviewData(name: "mightyK1ngRichard", messages: [])
        viewModel.connectWebSocket()
    }
    return ChatView()
        .environmentObject(viewModel)
}

// MARK: - Constants

private extension ChatView {

    enum Constants {
        static let tgBackground: Image = .tgBackground
        static let placeholder = "Message"
        static let paperplane = "paperplane"
        static func joinChatMessage(userName: String) -> String { "\(userName) вступил в чат" }
        static func quitChatMessage(userName: String) -> String { "\(userName) покинул чат" }
        static let messageBackgroundColor = Color(red: 103/255, green: 77/255, blue: 122/255)
        static let textColor: Color = MKRColor<TextPalette>.textPrimary.color
        static let textFieldBackgroundColor = MKRColor<BackgroundPalette>.bgPrimary.color
        static let textFieldStrokeColor = MKRColor<SeparatorPalette>.textFieldStrokeColor.color
        static let iconColor = Color(red: 127/255, green: 127/255, blue: 127/255)
        static let gradientBackgroundColor: [Color] = [
            Color(red: 168/255, green: 255/255, blue: 59/255),
            Color(red: 111/255, green: 135/255, blue: 255/255),
            Color(red: 215/255, green: 161/255, blue: 255/255),
            Color(red: 113/255, green: 190/255, blue: 255/255),
        ]
    }
}
