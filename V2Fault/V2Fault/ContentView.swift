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
    @State private var uuid: UUID = UUID()  // Add a state property for the UUID

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
                    print("decodedAudio:\(decodedAudio)")
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
        .onAppear {
            // Generate a new UUID when the view appears
            uuid = UUID()
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
        // Generate a new UUID when the reset button is pressed
        uuid = UUID()
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


        let dataToSend = DataToSend(textInput: textInput, audioBase64: audioBase64, imageBase64: imageBase64, uuid: uuid.uuidString)

        guard let jsonData = try? JSONEncoder().encode(dataToSend) else {
            print("Error encoding data to JSON")
            return
        }
        // print("encoding jsondata\n: \(String(data: jsonData, encoding: .utf8) ?? "Error converting to string")")
        
        /*
         for debug
        do {
            // Get the documents directory
            let documentsDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            
            // Append the file name to the directory
            let fileURL = documentsDirectory.appendingPathComponent("send.log")
            
            // Write the JSON data to the file
            try jsonData.write(to: fileURL)
            
            print("JSON data written to \(fileURL)")
        } catch {
            print("Error writing JSON data to file: \(error.localizedDescription)")
        }
         */

        guard let url = URL(string: "https://hackathon202312.azurewebsites.net/api/hackathon202312") else {
        // guard let url = URL(string: "http://localhost:7071/api/hackathon202312") else { print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        // Increase timeout interval
        request.timeoutInterval = 90 // or any other value in seconds
        print("request json data:\(String(describing: jsonData))")

        URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle the response or error as needed
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else if let data = data {
                do {
                    /*
                     for debug about response
                    print("response:\n\(String(describing: response))")
                    print("response data:\n\(data)")
                    do {
                        // Get the documents directory
                        let documentsDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                        
                        // Append the file name to the directory
                        let fileURL = documentsDirectory.appendingPathComponent("response.log")
                        
                        // Write the JSON data to the file
                        try data.write(to: fileURL)
                        
                        print("JSON data written to \(fileURL)")
                    } catch {
                        print("Error writing JSON data to file: \(error.localizedDescription)")
                    }
                     */
                    
                    // Decode JSON response
                    let decoder = JSONDecoder()
                    let dataContainer = try decoder.decode(DataContainer.self, from: data)

                    // Access data fields
                    let textData = dataContainer.text
                    let audioData = dataContainer.audio

                    // Update ContentView properties
                    decodedText = textData
                    decodedAudio = audioData?.base64DecodedData
                    // Assuming decodedAudio is of type Data

                    /*
                    // for debug about response audio.
                    if let decodedAudio = decodedAudio {
                        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent("response_audio.wav")

                        do {
                            try decodedAudio.write(to: fileURL)
                            print("Successfully saved decoded audio to \(fileURL)")
                        } catch {
                            print("Error saving decoded audio: \(error.localizedDescription)")
                        }
                    }
                    */

                    // Handle the data as needed
                    print("Text Data: \(textData?.count ?? -1)")
                    print("Audio Data: \(audioData?.count ?? -1)")
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
            print("decodedData: \(String(describing: decodedData))")
            if decodedData != nil {
                // Save decodedData to a temporary file
                let tempWavURL = FileManager.default.temporaryDirectory.appendingPathComponent("response_audio.wav")
                try decodedData!.write(to: tempWavURL, options: .atomic)
                
                // Convert WAV to M4A using AVAssetExportSession
                let tempM4AURL = FileManager.default.temporaryDirectory.appendingPathComponent("response_audio.m4a")
                try convertWAVtoM4A(inputURL: tempWavURL, outputURL: tempM4AURL)
                
                // Play the M4A audio
                audioPlayerManager.playAudio(url: tempM4AURL)
            } else {
                print("Error decoding audio because decodedData is nil")
            }
            /*
            // for m4a format file
            if let audioData = decodedData {
                audioPlayerManager.playAudio(data: audioData)
            }
             */
        } catch {
            print("Error decoding audio data: \(error.localizedDescription)")
        }
    }
    
    private func convertWAVtoM4A(inputURL: URL, outputURL: URL) throws {
        let asset = AVURLAsset(url: inputURL)
        let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A)
        
        guard exportSession != nil else {
            throw NSError(domain: "AudioConversionError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not create AVAssetExportSession."])
        }
        
        exportSession!.outputFileType = AVFileType.m4a
        exportSession!.outputURL = outputURL
        
        exportSession!.exportAsynchronously {
            if exportSession!.status == .completed {
                print("Audio conversion completed successfully.")
            } else if exportSession!.status == .failed {
                print("Audio conversion failed: \(exportSession!.error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
