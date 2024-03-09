//
//  UserCell.swift
//  chatSwiftUI
//
//  Created by Печик Ирина on 09.03.2024.
//

import SwiftUI

// MARK: View for user cell
struct UserCell: View {
    // MARK: - Fields initialization
    var userName: String
    var onlineStatus: String
    
    // MARK: - Chat cell body
    var body: some View {
        HStack {
            Text(userName)
                .font(.title2)
            Spacer()
            Text(onlineStatus)
                .foregroundStyle(onlineStatus == "online" ? .green : .red)
        }
    }
}

#Preview {
    UserCell(userName: "name", onlineStatus: "online")
}
