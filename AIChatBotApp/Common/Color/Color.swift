//
//  Color.swift
//  AIChatBotApp
//
//  Created by Muvi on 29/08/26.
//

import Foundation
import SwiftUI

internal extension Color {
    
    static var backgroundGradient: LinearGradient {
        .init(
            colors: [
                Color(red: 180/255, green: 182/255, blue: 246/255),
                Color(red: 222/255, green: 226/255, blue: 248/255),
                Color(red: 238/255, green: 240/255, blue: 252/255)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    static var sendMessageGradient: LinearGradient {
        .init(
            colors: [
                Color(red: 175/255, green: 230/255, blue: 255/255),
                Color(red: 150/255, green: 120/255, blue: 245/255),
                Color(red: 115/255, green: 80/255, blue: 220/255)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    static var receiveMessageGradient: LinearGradient {
        .init(
            colors: [
                Color.white,
                Color(red: 238/255, green: 240/255, blue: 252/255),
                Color(red: 222/255, green: 226/255, blue: 248/255)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}
