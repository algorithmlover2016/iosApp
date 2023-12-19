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

struct ContentView: View {
    @State private var textInput: String = ""
    @State private var isRecording: Bool = false
    @State private var isCameraActive: Bool = false
    // @State private var audioRecorder: AVAudioRecorder!
    @StateObject private var audioRecorderManager = AudioRecorderManager()
    @StateObject private var audioPlayerManager = AudioPlayerManager()

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

                Button(action: { [self] in
                    // Handle audio playback logic
                    if let audioURL = audioRecorderManager.audioURL {
                        if audioPlayerManager.isPlaying {
                            audioPlayerManager.stopAudio()
                        } else {
                            audioPlayerManager.playAudio(url: audioURL)
                        }
                    }
                }) {
                    Image(systemName: audioPlayerManager.isPlaying ? "stop.fill" : "play.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.green) // Adjust color as needed
                }
                .padding()

            }
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

            if let selectedImage = selectedImage {
                Text("Input image is the following:")
                    .padding()
                Image(uiImage: selectedImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                    .padding()
            }

            Text("Your input Text question is: \(textInput)")
                .padding()


        }
        .padding()
    }
}

class AudioRecorderManager: NSObject, ObservableObject, AVAudioRecorderDelegate {
    @Published var isRecording: Bool = false
    @Published var audioURL: URL? // Expose the audioURL property
    var audioRecorder: AVAudioRecorder!


    func startRecording() {
        // Implementation for starting recording
        let audioSession = AVAudioSession.sharedInstance()

        do {
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [])
            try audioSession.setActive(true)

            let audioSettings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 12000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]

            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let audioFilename = documentsPath.appendingPathComponent("audioRecording.m4a")

            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: audioSettings)
            audioRecorder.delegate = self
            audioRecorder.record()
        } catch {
            // Handle errors
            print("Error starting audio recording: \(error.localizedDescription)")
        }
    }

    func stopRecording() {
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
        } catch {
            // Handle errors
            print("Error stopping audio recording: \(error.localizedDescription)")
        }
        // Implementation for stopping recording
        // Set the audioURL property after recording is stopped
        audioURL = audioRecorder.url
    }

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        // Handle audio recording finish
        if flag {
            // Handle successful recording
            print("Audio recording successful")
        } else {
            // Handle recording failure
            print("Audio recording failed")
        }

    }
}

class AudioPlayerManager: NSObject, ObservableObject, AVAudioPlayerDelegate {
    @Published var isPlaying: Bool = false
    var audioPlayer: AVAudioPlayer?

    func playAudio(url: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            isPlaying = true
        } catch {
            // Handle errors
            print("Error playing audio: \(error.localizedDescription)")
        }
    }

    func stopAudio() {
        audioPlayer?.stop()
        isPlaying = false
    }

    // Implement AVAudioPlayerDelegate methods if needed
}


struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        picker.cameraCaptureMode = .photo
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePicker

        init(parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[.originalImage] as? UIImage {
                parent.selectedImage = selectedImage
            }

            picker.dismiss(animated: true)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
