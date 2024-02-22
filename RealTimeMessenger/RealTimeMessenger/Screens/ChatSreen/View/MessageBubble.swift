//
//  MessageBubble.swift
//  RealTimeMessenger
//
//  Created by Dmitriy Permyakov on 21.02.2024.
//

import SwiftUI

struct MessageBubble: View {
    let message: ChatMessage

    var body: some View {
        DefaultMessage
    }
}

// MARK: - Subviews

private extension MessageBubble {

    var DefaultMessage: some View {
        VStack(alignment: message.isYou ? .trailing : .leading) {
            HStack(alignment: .bottom) {
                Text(message.message)
                    .padding(.vertical, 6)
                    .padding(.leading, 10)

                HStack(spacing: 3) {
                    Text(message.time)
                        .foregroundStyle(.white.opacity(0.63))
                        .font(.system(size: 11, weight: .regular))

                    if message.isYou {
                        message.state.image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 14, height: 14)
                            .padding(.trailing, 5)
                            .foregroundStyle(message.state.imageColor)
                    }
                }
                .padding(.bottom, 4)
            }
            .padding(.trailing, 6)
            .background(Color.messageBackgroundColor, in: .rect(cornerRadius: 18))
            .frame(maxWidth: 320, alignment: message.isYou ? .trailing : .leading)
        }
        .frame(maxWidth: .infinity, alignment: message.isYou ? .trailing : .leading)
    }
}

// MARK: - Message State

private extension Message.State {

    var image: Image {
        switch self {
        case .error: return Image.errorImage
        case .received: return Image.receivedImage
        case .progress: return Image.progressImage
        }
    }

    var imageColor: Color {
        switch self {
        case .error: return Color(red: 1, green: 0, blue: 0)
        default: return .white.opacity(0.63)
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
                time: "10:10", 
                state: .received
            )
        )

        MessageBubble(
            message: .init(
                isYou: false,
                message: "Воу рил неплохо",
                userName: "mightyK1ngRichard",
                time: "10:10",
                state: .error
            )
        )
    }
}

// MARK: - Constants

private extension Image {

    static let receivedImage = Image("checkMark2")
    static let errorImage    = Image(systemName: "exclamationmark.arrow.circlepath")
    static let progressImage = Image(systemName: "clock.arrow.circlepath")
}
