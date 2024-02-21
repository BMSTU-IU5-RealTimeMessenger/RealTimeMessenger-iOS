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
                            MessageBubble(message: message)
                                .padding(.horizontal, 8)
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

            TextField("Message", text: $messageText)
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
                    messageText = ""
                } label: {
                    Image(systemName: "paperplane")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 22, height: 22)
                        .foregroundStyle(Color.iconColor)
                }
            }
        }
        .padding(.horizontal, 8)
    }
}

// MARK: - Preview

#Preview {
    let viewModel = ChatViewModel()
//    viewModel.messages = .mockData
    viewModel.userName = "mightyK1ingRichard"
//    viewModel.lastMessageID = [ChatMessage].mockData.last!.id
    viewModel.connectWebSocket()
    return ChatView()
        .environmentObject(viewModel)
}

// MARK: - Constants

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
