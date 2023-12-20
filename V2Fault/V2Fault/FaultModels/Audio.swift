//
//  Audio.swift
//  V2Fault
//
//  Created by bo yu on 20/12/2023.
//

import Foundation
import AVFoundation
import AudioKit

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
        guard audioRecorder != nil else {
            print("audioRecorder is nil, no audio need to stop")
            return
        }
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

        // /*
        // Convert the recorded audio to WAV using AudioKit
        convertToWAV()
        // */

    }
    // /*
    private func convertToWAV() {
        guard let m4aFilePath = audioRecorder.url.path as NSString? else { return }
        let wavFilePath = m4aFilePath.deletingPathExtension + ".wav"
        print("wavFilePath: \(wavFilePath)")

        var options = FormatConverter.Options()
        // any options left nil will assume the value of the input file
        options.format = .wav
        options.sampleRate = 48000
        options.bitDepth = 24

        let inputURL = URL(fileURLWithPath: m4aFilePath as String)
        let outputURL = URL(fileURLWithPath: wavFilePath)
        let converter = FormatConverter(inputURL: inputURL, outputURL: outputURL, options: options)
        converter.start { error in
            if let error = error {
                print("Error converting audio: \(error.localizedDescription)")
            } else {
                print("Audio conversion successful")
                self.audioURL = outputURL
            }
        }
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
    func playAudio(data: Data) {
        do {
            // Play the audio
            audioPlayer = try AVAudioPlayer(data: data)
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
