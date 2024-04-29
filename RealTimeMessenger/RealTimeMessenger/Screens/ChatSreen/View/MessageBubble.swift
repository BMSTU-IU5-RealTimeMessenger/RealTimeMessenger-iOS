//
//  MessageBubble.swift
//  RealTimeMessenger
//
//  Created by Dmitriy Permyakov on 21.02.2024.
//

import SwiftUI

struct MessageBubble: View {
    let message: ChatMessage
    var isYou: Bool { message.isYou }

    var body: some View {
        DefaultMessage
    }
}

// MARK: - Subviews

private extension MessageBubble {

    var DefaultMessage: some View {
        HStack(alignment: .bottom) {
            if !isYou {
                PersoneAvatar
            }
            
            VStack(alignment: isYou ? .trailing : .leading) {
                VStack(alignment: .leading, spacing: 2) {
                    if !isYou {
                        Text(message.userName)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(.mint.gradient)
                    }

                    HStack(alignment: .bottom) {
                        Text(message.message)
                            .foregroundStyle(Constants.textColor)

                        Text(message.time)
                            .foregroundStyle(.white.opacity(0.63))
                            .font(.system(size: 11, weight: .semibold))
                    }
                    .padding(.bottom, 4)
                }
                .padding(.leading, 10)
                .padding([.top], 6)
                .padding(.trailing, 8)
                .background(Constants.messageBackgroundColor, in: .rect(cornerRadius: 18))
                .frame(maxWidth: 320, alignment: isYou ? .trailing : .leading)
            }
        }
        .frame(maxWidth: .infinity, alignment: isYou ? .trailing : .leading)
    }

    var PersoneAvatar: some View {
        Circle()
            .fill(.mint.gradient)
            .frame(width: 32, height: 32)
            .overlay {
                Text("\(message.userName.first?.description.uppercased() ?? "😎")")
                    .foregroundStyle(.white)
                    .fontWeight(.semibold)
                    .fontDesign(.rounded)
            }
    }
}

// MARK: - Preview

#Preview {
    VStack {
        MessageBubble(
            message: .init(
                isYou: true,
                message: .message,
                userName: "mightyK1ngRichard",
                time: "10:10"
            )
        )

        MessageBubble(
            message: .init(
                isYou: false,
                message: "Воу рил неплохо",
                userName: "Пермяков Дмитрий",
                time: "10:10"
            )
        )
    }
}

// MARK: - Constants

private extension MessageBubble {

    enum Constants {
        static let messageBackgroundColor = MKRColor<BackgroundPalette>.messageBackgroundColor
        static let textColor = MKRColor<TextPalette>.textWhite.color
    }
}
