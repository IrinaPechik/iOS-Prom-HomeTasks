//
//  ChatCell.swift
//  chatSwiftUI
//
//  Created by Печик Ирина on 09.03.2024.
//

import SwiftUI

// MARK: View for chat cell
struct ChatCell: View {
    
    // MARK: - Fields initialization
    @State var message: String
    @State var senderName: String
    @State var messageTime: Date
    
    // MARK: - Methods initialization
    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        return dateFormatter.string(from: date)
    }
    
    // MARK: - Chat cell body
    var body: some View {
        HStack {
            Spacer()
            VStack(alignment: .leading) {
                Text(message)
                    .foregroundStyle(.gray)
                    .font(.title3)
                Text("by \(senderName) at \(formatDate(date: messageTime))")
                    .foregroundStyle(.white)
                    .background(.gray)
            }
            .frame(minWidth: 250, minHeight: 50)
        }
    }
}

#Preview {
    ChatCell(message: "message", senderName: "senderName", messageTime: Date.now)
}
