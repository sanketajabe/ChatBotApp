//
//  AIChatViewmodel.swift
//  AIChatBotApp
//
//  Created by Muvi on 29/08/26.
//

import SwiftUI
import FoundationModels

@Observable
@MainActor

///LanguageModelSession is the object that manages your app's interaction/conversation with Apple's language model, and you're keeping it private inside the ViewModel so your chat logic can use the same AI session.

final class AIChatViewmodel {
    var inputText : String = ""
    var aichatmodelSession = LanguageModelSession()
    
    var transcript : Transcript{
        aichatmodelSession.transcript
    }
    
    var issendDisabled : Bool{
        aichatmodelSession.isResponding || inputText.isEmpty
    }
    
    func resetChat(){
        aichatmodelSession = .init()
        print("chat reset completed")
    }
    
    func sendMessage() {
        let message = inputText.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        guard !message.isEmpty else {
            return
        }
        inputText.removeAll()
        
        Task {
            do {
                let response = try await aichatmodelSession.respond(
                    to: message
                )
                print(response)
            } catch {
                print(error)
            }
        }
    }
}


extension [Transcript.Segment]{
    func toString() -> String {
        let strings = self.compactMap { segment -> String? in
            if case let .text(textSegment) = segment {
                return textSegment.content
            }
            return nil
        }
        return strings.reduce("", +)
    }
}
