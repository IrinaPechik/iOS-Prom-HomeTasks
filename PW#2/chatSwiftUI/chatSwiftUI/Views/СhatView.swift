//
//  chatView.swift
//  chatSwiftUI
//
//  Created by Печик Ирина on 09.03.2024.
//

import SwiftUI
import Combine

// MARK: View for chat
struct ChatView: View {
    
    // MARK: - Fields initialization
    @ObservedObject var viewModel = ChatViewModel()
    @State private var typingMessage: String = ""
    @State private var didNotifyTyping = false
    @FocusState private var isInputActive: Bool
    
    var name: String = ""
    // MARK: - Private methods
    private func sendMessage() {
        viewModel.sendMessage(message: typingMessage, nickname: name)
        typingMessage = ""
        didNotifyTyping = false
    }
    
    // MARK: - Chat view body
    var body: some View {
        VStack {
            List {
                ForEach(viewModel.chatMessages.indices, id: \.self) { ind in
                    ChatCell(message: viewModel.chatMessages[ind]["message"] as? String ?? "", senderName: name, messageTime: Date.now)
                }
            }
            .listStyle(.plain)
            HStack {
                TextEditor(text: $typingMessage)
                    .frame(height: 50)
                    .onTapGesture {
                        if !didNotifyTyping {
                            viewModel.notifyUserStartedTyping(nickname: name)
                            didNotifyTyping = true
                        }
                    }
                    .onChange(of: isInputActive) {
                        if !isInputActive {
                            SocketIOManager.sharedInstance.sendStopTypingMessage(nickname: name)
                            didNotifyTyping = false
                        }
                    }

                Button(action: sendMessage) {
                    Text("Send")
                        .frame(width: 100, height: 50)
                        .background(.white)
                }
                
            }
            .padding()
            .background(Color.blue)
            .padding()
            .padding(.bottom, 270)
        }
        .onTapGesture {
            isInputActive = false
        }
        .onAppear {
            viewModel.connectAndPrepare()
        }
        .onDisappear {
            didNotifyTyping = false
        }

        .navigationBarTitle(Text("Chat"), displayMode: .inline)
    }
}


struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}

