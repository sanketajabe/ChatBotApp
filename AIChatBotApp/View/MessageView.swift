//
//  MessageView.swift
//  AIChatBotApp
//
//  Created by Muvi on 29/08/26.
//

import SwiftUI

struct MessageView: View {
    let message: String
    let isReceivingMessage: Bool
    let isLoading: Bool
    
    var body: some View {
        VStack(alignment: isReceivingMessage ? .leading : .trailing, spacing: 5) {
            
            Text(message)
                .padding()
                .background(bubbleGradient)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .foregroundStyle(Color.black)
                .shadow(
                    color: Color.black.opacity(0.8),
                    radius: 5,
                    x: 0,
                    y: 3
                )
            
            if isLoading {
                HStack {
                    Spacer()
                    ProgressView()
                        .scaleEffect(0.7)
                }
                .padding(.trailing, 10)
            }
        }
        .frame(
            maxWidth: .infinity,
            alignment: isReceivingMessage ? .leading : .trailing
        )
        .padding(.horizontal, 5)
        .padding(.vertical, 10)
    }
}

#Preview {
//    VStack{
//        MessageView(message: "How Are YOU?", isReceivingMessage: false)
//        MessageView(message: "I'M Good! How Can I Help You?", isReceivingMessage: true)
//    }
}


private extension MessageView{
    var bubbleGradient: LinearGradient {
        isReceivingMessage
        ? Color.receiveMessageGradient
        : Color.sendMessageGradient
    }
}


