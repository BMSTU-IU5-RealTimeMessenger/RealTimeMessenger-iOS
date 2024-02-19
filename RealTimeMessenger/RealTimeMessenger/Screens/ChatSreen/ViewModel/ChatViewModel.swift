//
//  ChatViewModel.swift
//  RealTimeMessenger
//
//  Created by Dmitriy Permyakov on 19.02.2024.
//

import Foundation

protocol ChatViewModelProtocol: AnyObject {
    func fetchData()
}

final class ChatViewModel: ObservableObject, ChatViewModelProtocol {
    @Published var messages: [ChatMessage] = []
}

extension ChatViewModel {

    func fetchData() {
        messages = .mockData
    }
}
