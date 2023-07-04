//
//  ViewController.swift
//  VAIosPlayer
//
//  Created by bo yu on 3/7/2023.
//

import AVFoundation
import AVKit
import UIKit

class ViewController: UIViewController {
    private var player: AVPlayer!
    private var playerLayer: AVPlayerLayer!
    private var imageView: UIImageView!
    private var startTime: CMTime?
    private var endTime: CMTime?
    private var timeObserverToken: Any?
    private var backwardButton: UIButton!
    private var playPauseButton: UIButton!
    private var forwardButton: UIButton!
    private var progressBar: UIProgressView!
    private var playbackControlsContainer: UIView!
    private var currentTimeLabel: UILabel!
    private var totalTimeLabel: UILabel!
    private var timeSlider: UISlider!

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    init(startTime: CMTime, endTime: CMTime) {
        super.init(nibName: nil, bundle: nil)
        self.startTime = startTime
        self.endTime = endTime
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        // Set up video player
        let videoPath = Bundle.main.path(forResource: "test", ofType: "mp4")!
        let videoURL = URL(fileURLWithPath: videoPath)
        player = AVPlayer(url: videoURL)
        playerLayer = AVPlayerLayer(player: player)
        // playerLayer.frame = view.bounds
        view.layer.addSublayer(playerLayer)

        // Add the image view
        let image = UIImage(named: "exampddle.png") // Update image file name and extension if needed
        imageView = UIImageView(image: image)
        imageView.center = view.center // Center the image view
        imageView.bounds = CGRect(x: 0, y: 0, width: 50, height: 50) // Set the size of the image view
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true

        // Set the border properties
        imageView.layer.borderWidth = 2.0
        imageView.layer.borderColor = UIColor.red.cgColor

        view.addSubview(imageView)

        // // Add the progress bar
        // progressBar = UIProgressView(progressViewStyle: .default)
        // progressBar.frame = CGRect(x: 0, y: view.bounds.height - 40, width: view.bounds.width, height: 40)
        // view.addSubview(progressBar)

        // Add the playback controls container
        playbackControlsContainer = UIView()
        playbackControlsContainer.frame = CGRect(x: 0, y: view.bounds.height - 80, width: view.bounds.width, height: 80)
        print("view.bounds.height: \(view.bounds.height), view.bounds.width.width: \(view.bounds.width)")
        view.addSubview(playbackControlsContainer)

        // Add the playback control buttons
        let buttonSize = CGSize(width: 40, height: 40)

        backwardButton = UIButton(type: .system)
        backwardButton.setImage(UIImage(systemName: "gobackward"), for: .normal)
        backwardButton.addTarget(self, action: #selector(backwardButtonTapped), for: .touchUpInside)
        backwardButton.frame = CGRect(origin: CGPoint.zero, size: buttonSize)

        playPauseButton = UIButton(type: .system)
        playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        playPauseButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        playPauseButton.frame = CGRect(origin: CGPoint.zero, size: buttonSize)

        forwardButton = UIButton(type: .system)
        forwardButton.setImage(UIImage(systemName: "goforward"), for: .normal)
        forwardButton.addTarget(self, action: #selector(forwardButtonTapped), for: .touchUpInside)
        forwardButton.frame = CGRect(origin: CGPoint.zero, size: buttonSize)

        playbackControlsContainer.addSubview(backwardButton)
        playbackControlsContainer.addSubview(playPauseButton)
        playbackControlsContainer.addSubview(forwardButton)

        // Add the current time label
        currentTimeLabel = UILabel()
        currentTimeLabel.textColor = .black
        currentTimeLabel.textAlignment = .left
        currentTimeLabel.font = UIFont.systemFont(ofSize: 14)
        playbackControlsContainer.addSubview(currentTimeLabel)

        // Add the total time label
        totalTimeLabel = UILabel()
        totalTimeLabel.textColor = .black
        totalTimeLabel.textAlignment = .right
        totalTimeLabel.font = UIFont.systemFont(ofSize: 14)
        playbackControlsContainer.addSubview(totalTimeLabel)

        // Add the time slider
        timeSlider = UISlider()
        timeSlider.minimumValue = 0
        timeSlider.addTarget(self, action: #selector(timeSliderValueChanged), for: .valueChanged)
        playbackControlsContainer.addSubview(timeSlider)

        // layoutPlaybackControls()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        playerLayer.frame = view.bounds
        playbackControlsContainer.frame = CGRect(x: 0, y: view.bounds.height - 80, width: view.bounds.width, height: 80)
        imageView.center = view.center
        layoutPlaybackControls()
        // print("view.bounds.height: \(view.bounds.height), view.bounds.width.width: \(view.bounds.width)")

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Set up time observer to track the video's current time
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1.0, preferredTimescale: CMTimeScale(NSEC_PER_SEC)), queue: .main) { [weak self] time in
            guard let self = self else { return }

            let currentTime = time.seconds
            self.currentTimeLabel.text = self.formatTime(Int(currentTime))


            // Show the image between start time and end time
            if let startTime = self.startTime, let endTime = self.endTime, currentTime >= startTime.seconds && currentTime <= endTime.seconds {
                self.imageView.isHidden = false
            } else {
                self.imageView.isHidden = true
            }

            // Update the current time label
            self.currentTimeLabel.text = self.formatTime(currentTime)

            // Update the total time label
            let totalTime = self.player.currentItem?.duration.seconds ?? 0
            self.timeSlider.value = Float(currentTime / totalTime)
            // Update the time slider value
            self.totalTimeLabel.text = self.formatTime(Int(self.player.currentItem?.duration.seconds ?? 0))
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        // Remove the time observer and player when the view disappears
        if let token = timeObserverToken {
            player.removeTimeObserver(token)
            timeObserverToken = nil
        }
        player = nil
    }

    // Function to set the start time during video playback
    func setStartTime(_ startTime: CMTime) {
        self.startTime = startTime
        player.seek(to: startTime)
    }

    // Function to set the end time during video playback
    func setEndTime(_ endTime: CMTime) {
        self.endTime = endTime
    }

    // Button action for playing or pausing the video
    @objc func playButtonTapped() {
        if player.rate == 0 {
            // Video is paused, play it
            player.play()
            playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        } else {
            // Video is playing, pause it
            player.pause()
            playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
    }

    // Button action for forwarding the video
    @objc func forwardButtonTapped() {
        let currentTime = player.currentTime().seconds
        let duration = player.currentItem?.duration.seconds ?? 0
        let targetTime = currentTime + 10.0 // Forward by 10 seconds

        // Check if the target time is within the video duration
        if targetTime < duration {
            player.seek(to: CMTime(seconds: targetTime, preferredTimescale: CMTimeScale(NSEC_PER_SEC)))
        }
    }

    // Button action for rewinding the video
    @objc func backwardButtonTapped() {
        let currentTime = player.currentTime().seconds
        let targetTime = currentTime - 10.0 // Rewind by 10 seconds

        // Check if the target time is greater than or equal to zero
        if targetTime >= 0 {
            player.seek(to: CMTime(seconds: targetTime, preferredTimescale: CMTimeScale(NSEC_PER_SEC)))
        }
    }

    // Function to format the time in HH:MM:SS format
    func formatTime(_ time: Double) -> String {
        let totalSeconds = Int(time)
        return formatTime(totalSeconds)
    }

    // Function to handle time slider value changes
    @objc func timeSliderValueChanged() {
        let totalTime = player.currentItem?.duration.seconds ?? 0
        let targetTime = Double(timeSlider.value) * totalTime

        player.seek(to: CMTime(seconds: targetTime, preferredTimescale: CMTimeScale(NSEC_PER_SEC)))
    }

    func layoutPlaybackControls() {
        // Calculate the size and position of the playback controls
        let buttonSize = CGSize(width: 40, height: 40)
        let labelHeight: CGFloat = 20
        let sliderHeight: CGFloat = 20
        let padding: CGFloat = 10
        let buttonSpacing: CGFloat = 20
        let timeLabelWidth: CGFloat = 100

        let containerWidth = playbackControlsContainer.frame.width
        let totalButtonWidth = backwardButton.frame.width + playPauseButton.frame.width + forwardButton.frame.width + 2 * buttonSpacing
        let startX = (containerWidth - totalButtonWidth) / 2

        let containerHeight = playbackControlsContainer.frame.height
        let totalButtonHeight = buttonSize.height
        let startY = (containerHeight - totalButtonHeight) / 2

        backwardButton.frame = CGRect(origin: CGPoint(x: startX, y: startY), size: buttonSize)

        playPauseButton.frame = CGRect(origin: CGPoint(x: backwardButton.frame.maxX + buttonSpacing, y: startY), size: buttonSize)

        forwardButton.frame = CGRect(origin: CGPoint(x: playPauseButton.frame.maxX + buttonSpacing, y: startY), size: buttonSize)

        currentTimeLabel.frame = CGRect(x: buttonSpacing, y: (containerHeight - buttonSize.height - labelHeight) / 2, width: timeLabelWidth, height: labelHeight)
        timeSlider.frame = CGRect(x: padding, y: (containerHeight - buttonSize.height - labelHeight - sliderHeight) / 2, width: containerWidth - padding, height: sliderHeight)
        totalTimeLabel.frame = CGRect(x: containerWidth - timeLabelWidth - padding, y: (containerHeight - buttonSize.height - labelHeight) / 2, width: timeLabelWidth, height: labelHeight)

    }


    private func formatTime(_ time: Int) -> String {
        let hours = time / 3600
        let minutes = (time % 3600) / 60
        let seconds = (time % 3600) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
