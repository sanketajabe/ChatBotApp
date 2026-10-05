//
//  ContentView.swift
//  AIChatBotApp
//
//  Created by Muvi on 29/08/26.
//

import SwiftUI
import FoundationModels

struct AIChatBotView: View {
    @State private var viewModel = AIChatViewmodel()
    @State private var speechRecognizer = SpeechRecognizer()
    
    var body: some View {
        NavigationStack{
            ScrollViewReader { proxy in
                ScrollView{
                    if viewModel.transcript.isEmpty {
                        
                        emptyStateView
                        
                    } else {
                        LazyVStack(spacing : 8){
                            ForEach(viewModel.transcript) { message in
                                switch message {
                                    
                                case .instructions(_):
//                                    MessageView(
//                                        message: "",
//                                        isReceivingMessage: false,
//                                        isLoading: false
//                                    )
                                    EmptyView()
                                    
                                case let .prompt(prompt):
                                    MessageView(
                                        message: prompt.segments.toString(),
                                        isReceivingMessage: false,
                                        isLoading: false
                                    )
                                    .id(message.id)
                                    
                                case let .response(response):
                                    MessageView(
                                        message: response.segments.toString(),
                                        isReceivingMessage: true,
                                        isLoading: false
                                    )
                                    .id(message.id)
                                    
                                default:
                                    EmptyView()
                                }
                            }
//                            if viewModel.isLoading {
//                                
//                                LoadingMessageView()
//                                    .id("loading")
//                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                    }
                }
                .scrollIndicators(.hidden)
                .background(Color.backgroundGradient)
                .navigationTitle("AI Chat")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar{toolbaritems}
                .safeAreaInset(edge: .bottom){
                    inputFieldView
                }
            }
        }
    }
    
    @ToolbarContentBuilder
    var toolbaritems: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button(action: {
                // Refresh chat
                viewModel.resetChat()
            }) {
                Image(systemName: "gobackward")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(.black)
            }
        }
    }
    
    var inputFieldView : some View{
        HStack(spacing : 10){
            TextField("Ask me anything ...", text: $viewModel.inputText)
                .padding(16)
                .background(Color.receiveMessageGradient)
                .clipShape(Capsule())
                .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 3)
                .onSubmit {
                    viewModel.sendMessage()
                }
            
            Button(action: {
                if speechRecognizer.isRecording {
                    speechRecognizer.stopRecording()
                    
                    // Put the speech text into the text field
                    viewModel.inputText = speechRecognizer.transcript
                } else {
                    speechRecognizer.transcript = ""
                    speechRecognizer.StartRecording()
                }
            })  {
                Image(
                    systemName: speechRecognizer.isRecording
                    ? "stop.fill"
                    : "mic.fill")
                .font(.system(size: 30, weight: .medium))
                .foregroundStyle(.white)
                .padding(15)
                .background {
                    if speechRecognizer.isRecording {
                        Color.sendMessageGradient.opacity(1.0)
                    } else {
                        Color.sendMessageGradient.opacity(0.7)
                    }
                }
                .clipShape(Circle())
                .clipShape(Circle())
                
            }
            
            Button(action: {
                viewModel.sendMessage()
            }) {
                Image(systemName: "paperplane.fill")
                    .font(.system(size: 25, weight: .medium))
                    .foregroundStyle(.white)
                    .padding(15)
                    .background { Color.sendMessageGradient.opacity(viewModel.issendDisabled ? 0.33 : 1.0) }
                    .clipShape(Circle())
            }
            .disabled(viewModel.issendDisabled)
        }
        .padding()
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {

            Spacer()

            ZStack {
                Circle()
                    .fill(Color.sendMessageGradient)
                    .frame(width: 90, height: 90)

                Image(systemName: "sparkles")
                    .font(.system(size: 40))
                    .foregroundStyle(.white)
            }

            Text("How can I help?")
                .font(.system(size: 28, weight: .bold))

            Text("Ask me anything, get explanations,\nwrite code, brainstorm ideas and more.")
                .font(.system(size: 16))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            VStack(spacing: 12) {

                HStack(spacing: 12) {
                    suggestionButton(
                        title: "Explain AI",
                        icon: "lightbulb.fill"
                    )

                    suggestionButton(
                        title: "Write code",
                        icon: "chevron.left.forwardslash.chevron.right"
                    )
                }

                HStack(spacing: 12) {
                    suggestionButton(
                        title: "Summarize",
                        icon: "doc.text"
                    )

                    suggestionButton(
                        title: "Brainstorm",
                        icon: "sparkles"
                    )
                }
            }
            .padding(.horizontal)

            Spacer()
        }
    }
    
    private func suggestionButton(
        title: String,
        icon: String
    ) -> some View {

        Button {
            viewModel.inputText = title
            viewModel.sendMessage()
        } label: {

            HStack {
                Image(systemName: icon)

                Text(title)
                    .font(.system(size: 14, weight: .medium))
            }
            .foregroundStyle(.black)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(.white.opacity(0.8))
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .shadow(
                color: .black.opacity(0.08),
                radius: 8,
                y: 4
            )
        }
    }
    
}

#Preview {
    AIChatBotView()
}

