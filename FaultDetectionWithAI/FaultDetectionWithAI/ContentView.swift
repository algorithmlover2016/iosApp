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
            
            /*
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
             Text("Camera View")
             }
             */
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
            }
            
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                    .padding()
            }
            
            Text("Your question is: \(textInput)")
                .padding()
            
            
        }
        .padding()
    }
    
    private func startRecording() {}
    
    private func stopRecording() {}
}

class AudioRecorderManager: NSObject, ObservableObject, AVAudioRecorderDelegate {
    @Published var isRecording: Bool = false
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

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
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
