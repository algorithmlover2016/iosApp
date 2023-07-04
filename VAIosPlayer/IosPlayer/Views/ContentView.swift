//
//  ContentView.swift
//  VAIosPlayer
//
//  Created by bo yu on 3/7/2023.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    let startTime: CMTime // Specify the desired start time
    let endTime: CMTime // Specify the desired end time
    
    var body: some View {
        VideoPlayerView(startTime: startTime, endTime: endTime)
            .edgesIgnoringSafeArea(.all)
    }
}

struct VideoPlayerView: UIViewControllerRepresentable {
    let startTime: CMTime // The desired start time
    let endTime: CMTime // The desired end time
    
    func makeUIViewController(context: Context) -> ViewController {

        // let startTime = CMTime(seconds: 180, preferredTimescale: 1) // Set start time to 3:00 (180 seconds)
        // let endTime = CMTime(seconds: 300, preferredTimescale: 1) // Set end time to 5:00 (300 seconds)
        let viewController = ViewController(startTime: startTime, endTime: endTime)
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
        // Update the view controller if needed
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(startTime: CMTime(seconds: 30, preferredTimescale: CMTimeScale(NSEC_PER_SEC)), endTime: CMTime(seconds: 300, preferredTimescale: CMTimeScale(NSEC_PER_SEC))) // Specify the desired start and end times
    }
}

