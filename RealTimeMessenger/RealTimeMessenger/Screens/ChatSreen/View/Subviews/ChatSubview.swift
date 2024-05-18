//
//  ChatSubview.swift
//  RealTimeMessenger
//
//  Created by Dmitriy Permyakov on 19.05.2024.
//

import SwiftUI

extension ChatView {

    var MainView: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.messages) { message in
                        MessageBlockView(message: message)
                    }
                }

                HStack { Spacer() }
                    .id(Constants.scrollIdentifier)
                    .padding(.bottom, 50)
            }
            .onTapGesture {
                isInputing = false
            }
            .background {
                BackgroundView
                    .ignoresSafeArea()
            }
            .overlay(alignment: .bottom) {
                TextFieldBlock
            }
            .onSubmit(of: .text) {
                didTapSendMessage()
            }
            .onChange(of: viewModel.lastMessageID) { _, _ in
                withAnimation {
                    proxy.scrollTo(Constants.scrollIdentifier, anchor: .bottom)
                }
            }
        }
    }

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
            Constants.paperClip

            CustomTextField

            SendButton
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(.ultraThinMaterial)
    }

    var CustomTextField: some View {
        TextField(Constants.placeholder, text: $messageText)
            .submitLabel(.return)
            .focused($isInputing)
            .padding(.vertical, 6)
            .padding(.horizontal, 13)
            .background(Constants.textFieldBackgroundColor, in: .rect(cornerRadius: 20))
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(lineWidth: 1)
                    .fill(Constants.textFieldStrokeColor)
            }
    }

    @ViewBuilder
    var SendButton: some View {
        if messageText.isEmpty {
            Image.record
                .frame(width: 22, height: 22)

        } else {
            Button(action: didTapSendMessage, label: {
                Image(systemName: Constants.paperplane)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 22, height: 22)
                    .foregroundStyle(Constants.iconColor)
            })
        }
    }

    func MessageJoinText(text: String) -> some View {
        Text(text)
            .font(.caption)
            .padding(.horizontal)
            .padding(.vertical, 6)
            .background(Constants.infoBgColor, in: .capsule)
            .multilineTextAlignment(.center)
            .padding(.horizontal)
    }
}

// MARK: - Preview

#Preview {
    ChatView()
        .environment(ChatViewModel.mockData)
}

// MARK: - Constants

private extension ChatView {

    enum Constants {
        static let paperClip: Image = .paperClip
        static let tgBackground: Image = .tgBackground
        static let scrollIdentifier = "SCROLL_ID"
        static let placeholder = String(localized: "Message")
        static let paperplane = "paperplane"
        static func joinChatMessage(userName: String) -> String {
            "\(userName) " + String(localized: "joined the chat")
        }
        static func quitChatMessage(userName: String) -> String {
            "\(userName) " + String(localized: "left the chat")
        }
        static let infoBgColor = MKRColor<BackgroundPalette>.bgInfo.color.opacity(0.7)
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
