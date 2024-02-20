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
        ScrollView {
            LazyVStack {
                ForEach(viewModel.messages, id: \.self.id) { message in
                    MessageView(message: message)
                        .padding(.horizontal, 14)
                }
            }
        }
        .overlay(alignment: .bottom) {
            TextFieldBlock
                .padding(.vertical, 6)
                .background(Color.bottomBackgroundColor)
        }
        .background {
            BackgroundView
                .ignoresSafeArea()
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

    func MessageView(message: ChatMessage) -> some View {
        HStack {
            if message.isYou {
                Spacer()
            }

            HStack(alignment: .bottom) {
                Text(message.message)
                    .padding(.vertical, 6)
                    .padding(.leading, 10)

                Text(message.time)
                    .foregroundStyle(.white.opacity(0.63))
                    .font(.system(size: 11, weight: .regular))
                    .padding(.bottom, 4)
                    .padding(.trailing, 12)
            }
            .background(Color.messageBackgroundColor, in: .rect(cornerRadius: 18))

            if !message.isYou {
                Spacer()
            }
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

            Button {
                print("ОТПРАВИТЬ СООБЩЕНИЕ")
                viewModel.sendMessage(message: messageText)
                messageText = ""
            } label: {
                Image.record
            }
        }
        .padding(.horizontal, 8)
    }
}

// MARK: - Preview

#Preview {
    let viewModel = ChatViewModel()
    viewModel.messages = .mockData
    return ChatView()
        .environmentObject(viewModel)
}

// MARK: - Constants

private extension [Color] {

    static let gradientBackgroundColor: [Color] = [
        Color(red: 168/255, green: 255/255, blue: 59/255),
        Color(red: 111/255, green: 135/255, blue: 255/255),
        Color(red: 215/255, green: 161/255, blue: 255/255),
        Color(red: 113/255, green: 190/255, blue: 255/255),
    ]
}
