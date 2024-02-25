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
            VStack(spacing: 0) {
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.messages) { message in
                            switch message.kind {
                            case .bubble:
                                MessageBubble(message: message)
                                    .padding(.horizontal, 8)
                                
                            case .join:
                                MessageJoinText(userName: .joinChatMessage(userName: message.userName))

                            case .quit:
                                MessageJoinText(userName: .quitChatMessage(userName: message.userName))
                            }
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
                    .background(Color.bottomBackgroundColor)
            }
            .frame(maxHeight: .infinity)
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

    var BackgroundView: some View {
        LinearGradient(
            colors: .gradientBackgroundColor,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .mask {
            Image.tgBackground
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    var TextFieldBlock: some View {
        HStack {
            Image.paperClip

            TextField(String.placeholder, text: $messageText)
                .padding(.vertical, 6)
                .padding(.horizontal, 13)
                .background(Color.textFieldBackgroundColor, in: .rect(cornerRadius: 20))
                .overlay {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(lineWidth: 1)
                        .fill(Color.textFieldStrokeColor)
                }

            if messageText.isEmpty {
                Image.record
                    .frame(width: 22, height: 22)
                
            } else {
                Button {
                    viewModel.sendMessage(message: messageText)
                    messageText = .clear
                } label: {
                    Image(systemName: .paperplane)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 22, height: 22)
                        .foregroundStyle(Color.iconColor)
                }
            }
        }
        .padding(.horizontal, 8)
    }

    func MessageJoinText(userName: String) -> some View {
        Text(userName)
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
    viewModel.setPreviewData(name: "mightyK1ngRichard", messages: [])
    viewModel.connectWebSocket()
    return ChatView()
        .environmentObject(viewModel)
}

// MARK: - Constants

private extension String {

    static let placeholder = "Message"
    static let paperplane = "paperplane"
    static func joinChatMessage(userName: String) -> String { "\(userName) вступил в чат" }
    static func quitChatMessage(userName: String) -> String { "\(userName) покинул чат" }
}

private extension Color {

    static let iconColor = Color(red: 127/255, green: 127/255, blue: 127/255)
}

private extension [Color] {

    static let gradientBackgroundColor: [Color] = [
        Color(red: 168/255, green: 255/255, blue: 59/255),
        Color(red: 111/255, green: 135/255, blue: 255/255),
        Color(red: 215/255, green: 161/255, blue: 255/255),
        Color(red: 113/255, green: 190/255, blue: 255/255),
    ]
}
