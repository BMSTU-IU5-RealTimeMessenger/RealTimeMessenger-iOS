//
//  StartView.swift
//  RealTimeMessenger
//
//  Created by Dmitriy Permyakov on 22.02.2024.
//

import SwiftUI

struct StartView: View {
    @State private var text: String = .clear
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = .clear
    @StateObject private var nav = Navigation()
    @State private var viewModel = ChatViewModel()

    var body: some View {
        NavigationStack(path: $nav.path) {
            GeometryReader {
                let size = $0.size
                VStack {
                    TitleView

                    InputNameView
                }
                .foregroundStyle(.white)
                .frame(width: size.width, height: size.height)
                .offset(y: -size.height.half.half.half)
                .background(BackgoundShapes(size: size))
                .background(Constants.bgColor)
                .overlay(alignment: .bottom) {
                    StartButton
                        .padding(.bottom, size.height.half.half * 0.7)
                }
            }
            .onTapGesture {
                UIApplication.shared.sendAction(
                    #selector(UIResponder.resignFirstResponder),
                    to: nil,
                    from: nil,
                    for: nil
                )
            }
            .navigationDestination(for: String.self) { userName in
                ChatView()
                    .environmentObject(nav)
                    .environment(viewModel)
                    .onAppear {
                        text = .clear
                    }
            }

        }
        .tint(.primary)
        .alert(
            Constants.alertTitle,
            isPresented: $showAlert,
            presenting: alertMessage
        ) { _ in } message: { errorMessage in
            Text(errorMessage)
        }
    }
}

private extension StartView {

    func BackgoundShapes(size: CGSize) -> some View {
        Rectangle()
            .fill(Constants.bgGradient)
            .frame(
                width: size.width * 0.9,
                height: pow((size.width.squared + size.height.squared), 0.5)
            )
            .rotationEffect(.degrees(45))
            .offset(x: -80, y: -80)
    }

    var TitleView: some View {
        Text(Constants.title)
            .font(.system(size: UIDevice.isIpad ? 50 : 30, weight: .bold, design: .rounded))
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .padding(.leading)
    }

    @ViewBuilder
    var InputNameView: some View {
        TextField(String.clear, text: $text)
            .font(.system(size: 18, weight: .semibold, design: .rounded))
            .padding(.horizontal)
            .placeholder(when: text.isEmpty) {
                Text(Constants.placeholder)
                    .foregroundColor(.white.opacity(0.7))
                    .padding(.leading)
                    .horizontalAlignment(.leading)
            }
            .padding(.top, 100)

        RoundedRectangle(cornerRadius: 10)
            .frame(maxWidth: .infinity, maxHeight: 2)
            .padding(.horizontal, 10)
            .foregroundColor(.white.opacity(0.4))
    }

    var StartButton: some View {
        Button {
            viewModel.didTapSignIn(userName: text) { apiError in
                if let error = apiError?.alertMessage {
                    showAlert = true
                    alertMessage = error
                    return
                }
                nav.path.append(text)
            }
        } label: {
            Text(Constants.startMesseging)
                .font(.system(size: 16, weight: .regular))
                .tint(.white)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Constants.bgGradient, in: .capsule)
        .disabled(text.isEmpty)
    }
}

// MARK: - Preview

#Preview {
    StartView()
}

// MARK: - Constants

private extension StartView {

    enum Constants {
        static let alertTitle = String(localized: "Login error")
        static let title = String(localized: "Welcome to") + "\nRealTimeMessenger"
        static let placeholder = String(localized: "Enter the user name")
        static let startMesseging = String(localized: "Join the chat")
        static let bgColor = MKRColor<BackgroundPalette>.bgSecondary.color
        static let bgGradient = LinearGradient(
            colors: [.pink, .purple],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
