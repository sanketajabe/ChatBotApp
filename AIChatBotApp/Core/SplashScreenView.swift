//
//  SplashScreenView.swift
//  AIChatBotApp
//
//  Created by Muvi on 05/09/26.
//

import SwiftUI

struct SplashScreenView: View {
    var body: some View {
        ZStack{
            Image("SplashScreen")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
    }
}

#Preview {
    SplashScreenView()
}
