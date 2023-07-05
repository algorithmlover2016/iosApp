//
//  ViewController.swift
//  VideoPlayerReconstruct
//
//  Created by bo yu on 4/7/2023.
//

import UIKit
import AVFoundation
import AVKit

// /*
class ViewController: UIViewController {

    var player: AVPlayer?
    var playerViewController: AVPlayerViewController?
    // var useLocalFile: Bool
    var useLocalFile: Bool {
            didSet {
                setupPlayer()
            }
    }

    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var progressSlider: UISlider!


    init(useLocalFile: Bool = true) {
        self.useLocalFile = useLocalFile
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let videoUrl = selectedVideoURL()

        player = AVPlayer(url: videoUrl)
        playerViewController = AVPlayerViewController()
        playerViewController?.player = player
        playerViewController?.delegate = self

        addChild(playerViewController!)
        view.addSubview(playerViewController!.view)
        playerViewController!.view.frame = view.bounds

        // Observe player's current time
        player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: CMTimeScale(NSEC_PER_SEC)), queue: DispatchQueue.main) { [weak self] time in
            guard let duration = self?.player?.currentItem?.duration else { return }
            let totalSeconds = CMTimeGetSeconds(duration)
            let currentSeconds = CMTimeGetSeconds(time)
            let progress = Float(currentSeconds / totalSeconds)
            self?.progressSlider?.value = progress
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

    @IBAction func toggleFileOption() {
        useLocalFile.toggle()
        // print("ViewController useLocalFile: \(useLocalFile)")

    }

    private func selectedVideoURL() -> URL {
        if useLocalFile, let localVideoURL = localVideoURL() {
            return localVideoURL
        } else {
            return remoteVideoURL()
        }
    }

    private func localVideoURL() -> URL? {
        guard let localVideoPath = Bundle.main.path(forResource: "test", ofType: "mp4"),
              FileManager.default.fileExists(atPath: localVideoPath) else {
            return nil
        }
        return URL(fileURLWithPath: localVideoPath)
    }

    private func remoteVideoURL() -> URL {
        return URL(string: "https://joy.videvo.net/videvo_files/video/premium/partners0524/large_watermarked/BB_01bbb1fd-672a-4b8c-81fb-34a99ced87d4_preview.mp4")!
    }

    private func setupPlayer() {
        let videoURL = selectedVideoURL()
        // print("set new videoURL: \(videoURL)")

        player?.replaceCurrentItem(with: AVPlayerItem(url: videoURL))
    }


}

extension ViewController: AVPlayerViewControllerDelegate {
    func playerViewControllerDidStopPictureInPicture(_ playerViewController: AVPlayerViewController) {
        // Dismiss the full screen player when Picture in Picture mode ends
        playerViewController.dismiss(animated: true, completion: nil)
    }
}
