//
//  ContentView.swift
//  V2Fault
//
//  Created by bo yu on 19/12/2023.
//

//
//  ContentView.swift
//  FaultDetectionWithAI
//
//  Created by bo yu on 19/12/2023.
//

import SwiftUI
import AVFoundation
import UIKit
import AudioKit

struct ContentView: View {
    @State private var textInput: String = ""
    @State private var isRecording: Bool = false
    @State private var isCameraActive: Bool = false
    @StateObject private var audioRecorderManager = AudioRecorderManager()
    @StateObject private var audioPlayerManager = AudioPlayerManager()
    @State private var decodedText: String?
    @State private var decodedAudio: Data?

    @State private var selectedImage: UIImage?

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(.blue)
                .padding()

            Text("Welcome to use Fault Detection!")
                .padding()

            TextField("Enter your question", text: $textInput)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            // Display input text if not empty
            if !textInput.isEmpty {
                Text("Input Text Is: \(textInput)")
                    .padding()
            }

            HStack { // Use HStack to arrange buttons horizontally
                Button(action: { [self] in
                    // Handle voice recording logic
                    audioRecorderManager.isRecording.toggle()

                    if audioRecorderManager.isRecording {
                        audioRecorderManager.startRecording()
                    } else {
                        audioRecorderManager.stopRecording()
                    }
                }) {
                    Image(systemName: audioRecorderManager.isRecording ? "mic.fill" : "mic")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(audioRecorderManager.isRecording ? .red : .primary)
                }
                .padding()
                // Display audio player if there is a recorded audio file
                if let audioURL = audioRecorderManager.audioURL {
                    HStack {
                        Text("Audio Recording:")
                            .bold()
                            .foregroundColor(.blue)
                        Button(action: { [self] in
                            // Handle audio playback logic
                            if audioPlayerManager.isPlaying {
                                audioPlayerManager.stopAudio()
                            } else {
                                audioPlayerManager.playAudio(url: audioURL)
                            }
                        }) {
                            Image(systemName: audioPlayerManager.isPlaying ? "stop.fill" : "play.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.green)
                        }
                    }
                    .padding()
                }
            }

            VStack {
                Button(action: {
                    // Handle camera logic
                    self.isCameraActive.toggle()
                }) {
                    Image(systemName: "camera")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.primary)
                }
                .sheet(isPresented: $isCameraActive) {
                    // Present camera view here
                    ImagePicker(selectedImage: self.$selectedImage)
                        .edgesIgnoringSafeArea(.all) // Ignore safe area to allow landscape orientation

                }

                // Display selected image if available
                if let selectedImage = selectedImage {
                    HStack {
                        Text("Input Image Is:")
                            .bold()
                            .foregroundColor(.blue)
                        Image(uiImage: selectedImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 200)
                            .padding()
                    }
                }

            }

            HStack {
                // Reset button
                Button(action: { [self] in
                    reset()
                }) {
                    Text("Reset")
                        .bold()
                        .foregroundColor(.red)
                }
                .padding()

                // Submit button
                Button(action: { [self] in
                    send()
                }) {
                    Text("Send")
                        .bold()
                        .foregroundColor(.blue)
                }
                .padding()
            }

            // Display play button for decoded audio
            if let decodedAudio = decodedAudio {
                Button(action: {
                    // Handle playing the decoded audio
                    playDecodedAudio(data: decodedAudio)
                }) {
                    Image(systemName: "play.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.green)
                }
                .padding()
            }
            // Display decoded text
            if let decodedText = decodedText {
                Text("Decoded Text:")
                    .bold()
                    .foregroundColor(.blue)
                Text(decodedText)
                    .padding()
            }

        }

        .padding()
    }

    private func reset() {
        textInput = ""
        isRecording = false
        audioRecorderManager.stopRecording()
        audioPlayerManager.stopAudio()
        audioRecorderManager.audioURL = nil
        selectedImage = nil
    }

    private func send() {
        // Implement logic to send a request to the endpoint
        // You can use URLSession, Alamofire, or any other networking library here
        var audioBase64 :String? = nil
        var imageBase64 :String? = nil
        if let audioURL = audioRecorderManager.audioURL {
            audioBase64 = base64Encode(audioURL)
        }
        if let imageData = selectedImage?.jpegData(compressionQuality: 1.0) {
            imageBase64 = imageData.base64EncodedString()
        }

        // Check if at least one of the values is not nil
        guard textInput.isNotEmpty || audioBase64 != nil || imageBase64 != nil else {
            print("All three values (textInput, audio, and image) are nil. Nothing to send.")
            return
        }


        let dataToSend = DataToSend(textInput: textInput, audioBase64: audioBase64, imageBase64: imageBase64)

        guard let jsonData = try? JSONEncoder().encode(dataToSend) else {
            print("Error encoding data to JSON")
            return
        }

        guard let url = URL(string: "https://www.example.com/rec") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle the response or error as needed
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else if let data = data {
                do {
                    // Decode JSON response
                    let decoder = JSONDecoder()
                    let serverResponse = try decoder.decode(ServerResponse.self, from: data)

                    // Access data fields
                    let textData = serverResponse.data.text
                    let audioData = serverResponse.data.audio

                    // Update ContentView properties
                    decodedText = textData
                    decodedAudio = audioData?.base64DecodedData

                    // Handle the data as needed
                    print("Code: \(serverResponse.code)")
                    print("Error Message: \(serverResponse.errormsg)")
                    print("Text Data: \(textData ?? "N/A")")
                    print("Audio Data: \(audioData ?? "N/A")")
                } catch {
                    print("Error decoding JSON: \(error.localizedDescription)")
                }
            }
        }.resume()
    }

    private func base64Encode(_ url: URL) -> String {
        do {
            let audioData = try Data(contentsOf: url)
            return audioData.base64EncodedString()
        } catch {
            print("Error encoding audio data to base64: \(error.localizedDescription)")
            return ""
        }
    }
    private func playDecodedAudio(data: Data) {
        do {
            // Decode base64 audio data
            let decodedData = Data(base64Encoded: data)

            // Play the audio
            if let audioData = decodedData {
                audioPlayerManager.playAudio(data: audioData)
            }
        } catch {
            print("Error decoding audio data: \(error.localizedDescription)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
