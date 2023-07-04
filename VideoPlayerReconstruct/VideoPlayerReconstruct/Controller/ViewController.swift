//
//  ViewController.swift
//  VideoPlayerReconstruct
//
//  Created by bo yu on 4/7/2023.
//

import UIKit
import AVFoundation
import AVKit

class ViewController: UIViewController {

    var player: AVPlayer?
    var playerViewController: AVPlayerViewController?
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var progressSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let videoURL = URL(string: "https://joy1.videvo.net/videvo_files/video/free/2019-05/large_watermarked/190516_06_AZ-LAGOA-30_preview.mp4")
        // https://joy.videvo.net/videvo_files/video/premium/partners0524/large_watermarked/BB_01bbb1fd-672a-4b8c-81fb-34a99ced87d4_preview.mp4
        player = AVPlayer(url: videoURL!)
        
        playerViewController = AVPlayerViewController()
        playerViewController?.player = player
        
        addChild(playerViewController!)
        view.addSubview(playerViewController!.view)
        playerViewController!.view.frame = view.bounds
        
        // Observe player's current time
        player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: CMTimeScale(NSEC_PER_SEC)), queue: DispatchQueue.main) { [weak self] time in
            guard let duration = self?.player?.currentItem?.duration else { return }
            let totalSeconds = CMTimeGetSeconds(duration)
            let currentSeconds = CMTimeGetSeconds(time)
            let progress = Float(currentSeconds / totalSeconds)
            self?.progressSlider.value = progress
        }
    }
    
    // Play button action
    @IBAction func playButtonPressed(_ sender: UIButton) {
        player?.play()
    }
    
    // Pause button action
    @IBAction func pauseButtonPressed(_ sender: UIButton) {
        player?.pause()
    }
    
    // Slider value changed action
    @IBAction func progressSliderValueChanged(_ sender: UISlider) {
        let duration = player?.currentItem?.duration.seconds ?? 0
        let currentTime = Double(sender.value) * duration
        let time = CMTime(seconds: currentTime, preferredTimescale: 1)
        player?.seek(to: time)
    }
}
