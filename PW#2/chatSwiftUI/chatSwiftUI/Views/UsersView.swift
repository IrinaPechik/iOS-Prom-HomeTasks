//
//  UsersView.swift
//  chatSwiftUI
//
//  Created by Печик Ирина on 09.03.2024.
//

import SwiftUI

struct UsersView: View {
    @State private var nickname: String = ""
    @State private var users: [[String: AnyObject]] = []
    @State private var showChatView: Bool = false
    @State private var showNicknameAlert: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                List(users.indices, id: \.self) { ind in
                    if let nickname = users[ind]["nickname"] as? String {
                        UserCell(userName: nickname, onlineStatus: isUserActive(userName: nickname) ? "online" : "offline")
                    } else {
                        Text("Unknown user")
                    }
                }
                Button(action: {
                    showChatView = true
                }, label: {
                    Text("Join chat")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }).disabled(showNicknameAlert)
                    .opacity(showNicknameAlert ? 0.5 : 1)
            }
            .navigationBarTitle("Chat App", displayMode: .inline)
            .navigationBarItems(trailing: Button(
                action: {
                    self.exitChat()
                }) {
                    Text("Exit")
                }
            )
            .alert("SocketChat", isPresented: $showNicknameAlert) {
                TextField("Enter your name", text: $nickname)
                Button("OK", action: {
                    if !nickname.isEmpty {
                        showNicknameAlert = false
                        SocketIOManager.sharedInstance.connectToServerWithNickname(nickname: nickname) { (userList: [[String : AnyObject]]?) in
                            DispatchQueue.global(qos: .background).async {
                                DispatchQueue.main.async {
                                    if userList != nil {
                                        self.users = userList!
                                    }
                                }
                            }
                        }
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            self.showNicknameAlert = true
                        }
                    }
                })
            } message: {
                Text("Please enter a nickname")
            }
            .onAppear {
                SocketIOManager.sharedInstance.establishConnection()
                showNicknameAlert = true
            }
            .sheet(isPresented: $showChatView) {
                ChatView(name: nickname)
            }
        }
    }

    
    func exitChat() {
        SocketIOManager.sharedInstance.exitChatWithNickname(nickname: nickname) {
            DispatchQueue.main.async {
                self.nickname = ""
                self.users.removeAll()
                showNicknameAlert = true
            }
        }
    }
    
    func isUserActive(userName: String) -> Bool {
        return userName == self.nickname ? true : false
    }

}

#Preview {
    UsersView()
}
