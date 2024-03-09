//
//  ChatViewModel.swift
//  chatSwiftUI
//
//  Created by Печик Ирина on 10.03.2024.
//

import Foundation

// MARK: View model for chat
class ChatViewModel: ObservableObject {
    
    // MARK: - Field initialization
    @Published var chatMessages = [[String: AnyObject]]()
    
    // MARK: - Methods initialization
    func connectAndPrepare() {
        SocketIOManager.sharedInstance.getChatMessage { [weak self] (messageInfo) -> Void in
            DispatchQueue.main.async {
                self?.chatMessages.append(messageInfo)
            }
        }
    }

    func sendMessage(message: String, nickname: String) {
        SocketIOManager.sharedInstance.sendMessage(message: message, withNickname: nickname)
    }
    
    func notifyUserStartedTyping(nickname: String) {
        SocketIOManager.sharedInstance.sendStartTypingMessage(nickname: nickname)
    }
}
