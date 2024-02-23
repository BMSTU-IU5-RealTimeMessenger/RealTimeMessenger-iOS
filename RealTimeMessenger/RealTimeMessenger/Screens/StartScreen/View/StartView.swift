//
//  StartView.swift
//  RealTimeMessenger
//
//  Created by Dmitriy Permyakov on 22.02.2024.
//

import SwiftUI

struct StartView: View {
    @State private var text: String = .clear
    @StateObject private var nav = Navigation()
    @StateObject private var viewModel = ChatViewModel()

    var body: some View {
        NavigationStack(path: $nav.path) {
            GeometryReader {
                let size = $0.size

                VStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 14) {
                        TitleText

                        SubtitleText
                    }
                    .foregroundStyle(.white)
                    .frame(height: size.height * .fraction)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, .hPadding)
                    .offset(y: 30)
                    .background(Color.bgColor.gradient)

                    VStack(spacing: 12) {
                        TextField(String.clear, text: $text)
                            .placeholder(when: text.isEmpty) {
                                Text(String.placeholder)
                                    .foregroundColor(.gray)
                            }
                            .foregroundStyle(.black)
                            .frame(height: .buttonHeight)
                            .padding(.horizontal, UIDevice.isSe ? 50 : 68)
                            .background(Color.textFieldColor, in: .capsule)
                            .padding(.horizontal, .hPadding)

                        Button {
                            viewModel.setUserName(name: text)
                            viewModel.connectWebSocket()
                            nav.path.append(text)
                        } label: {
                            Label(
                                title: {
                                    Text("Начать общение")
                                        .font(.system(size: 16, weight: .regular))
                                        .tint(.buttonTintColor)
                                },
                                icon: {
                                    Image("mail_outline_24px")
                                        .renderingMode(.template)
                                        .tint(.buttonTintColor)
                                }
                            )
                            .frame(height: .buttonHeight)
                            .frame(maxWidth: .infinity)
                            .background(Color.buttonBgColor, in: .capsule)
                            .padding(.horizontal, .hPadding)
                        }
                        .disabled(text.isEmpty)
                    }
                    .offset(y: -.buttonHeight.half)
                }
            }
            .background(Color.bgBottomColor.gradient)
            .navigationDestination(for: String.self) { userName in
                ChatView()
                    .environmentObject(nav)
                    .environmentObject(viewModel)
                    .onAppear {
                        text = .clear
                    }
            }
        }
        .preferredColorScheme(.dark)
    }
}

// MARK: - Preview

#Preview {
    StartView()
}

// MARK: - Constants

private extension StartView {

    var TitleText: some View {
        Text(String.title)
            .font(.system(size: UIDevice.isIpad ? 60 : 32, weight: .bold))
    }

    var SubtitleText: some View {
        Text(String.subtitle)
            .font(.system(size: UIDevice.isIpad ? 28 : 16, weight: .regular))
    }
}

private extension String {

    static let title = "RealTimeMessenger"
    static let subtitle = "Курсовая работа, МГТУ"
    static let placeholder = "Введите имя пользователя"
}

private extension CGFloat {

    static let buttonHeight: CGFloat = 52
    static let fraction: CGFloat = 0.7
    static let hPadding: CGFloat = 20
}

private extension Color {

    static let textFieldColor = Color(hex: 0xFFFFFF)
    static let buttonTintColor = Color(red: 218/255, green: 217/255, blue: 220/255)
    static let buttonBgColor = Color(hex: 0xBF08CB, alpha: 0.54)
    static let bgColor = Color(hex: 0x7723FF)
    static let bgBottomColor = Color(hex: 0xCBB4FF)
}

private extension View {

    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .center,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
