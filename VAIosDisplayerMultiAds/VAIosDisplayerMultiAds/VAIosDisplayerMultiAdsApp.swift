//
//  VAIosDisplayerMultiAdsApp.swift
//  VAIosDisplayerMultiAds
//
//  Created by bo yu on 4/7/2023.
//

import SwiftUI
import CoreMedia

@main
struct VAIosDisplayerMultiAdsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(startTime: CMTime(seconds: 30, preferredTimescale: CMTimeScale(NSEC_PER_SEC)), endTime: CMTime(seconds: 300, preferredTimescale: CMTimeScale(NSEC_PER_SEC))) // Specify the desired start and end times
        }
    }
}
