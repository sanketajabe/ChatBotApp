//
//  SpeechRecognizer.swift
//  AIChatBotApp
//
//  Created by Muvi on 30/08/26.
//

import Foundation
import SwiftUI
import AVFoundation
import Speech

@Observable
@MainActor
final class SpeechRecognizer {
    var transcript: String = ""
    var isRecording: Bool = false
    private let audioEngine = AVAudioEngine()
    
    private let speechRecognizer = SFSpeechRecognizer()
    private var recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
    private var recognizationTask: SFSpeechRecognitionTask? = nil
    
    func StartRecording() {
        transcript = ""
        recognizationTask?.cancel()
        recognizationTask = nil
        
        guard let speechRecognizer = speechRecognizer,
              speechRecognizer.isAvailable else {
            print("Speech recognizer is not available")
            return
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(
                .record,
                mode: .measurement,
                options: [.duckOthers]
            )
            
            try audioSession.setActive(
                true,
                options: .notifyOthersOnDeactivation
            )
            
            let request = SFSpeechAudioBufferRecognitionRequest()
            recognitionRequest = request
            
            let inputNode = audioEngine.inputNode
            
            // Remove any existing tap
            inputNode.removeTap(onBus: 0)
            
            let recordingFormat = inputNode.outputFormat(forBus: 0)
            
            guard recordingFormat.sampleRate > 0 else {
                print("Invalid recording format")
                return
            }
            
            inputNode.installTap(
                onBus: 0,
                bufferSize: 1024,
                format: recordingFormat
            ) { buffer, _ in
                request.append(buffer)
            }
            
            recognizationTask = speechRecognizer.recognitionTask(
                with: request
            ) { [weak self] result, error in
                
                guard let self else { return }
                
                if let result = result {
                    self.transcript =
                    result.bestTranscription.formattedString
                    
                    print("Transcript:", self.transcript)
                }
                
                if let error = error {
                    print("Speech recognition error:", error)
                    //self.stopRecording()
                }
            }
            
            audioEngine.prepare()
            try audioEngine.start()
            
            isRecording = true
            
            print("Recording started")
            
        } catch {
            print("Audio engine error:", error)
            isRecording = false
        }
    }
    
    func stopRecording() {
        
        audioEngine.stop()
        
        audioEngine.inputNode.removeTap(onBus: 0)
        
        recognitionRequest.endAudio()
        recognizationTask?.cancel()
        recognizationTask = nil
        
        isRecording = false
    }
}
