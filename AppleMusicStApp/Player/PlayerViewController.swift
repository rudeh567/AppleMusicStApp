import UIKit
import Foundation
import AVFoundation

class PlayerViewController: UIViewController {
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    
    @IBOutlet weak var playControlButton: UIButton!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var totalDurationLabel: UILabel!
    
    let simplePlayer = SimplePlayer.shared
    
    var timeObserver: Any?
    var isSeeking: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updatePlayButton()
        updateTime(time: CMTime.zero)
        
        // TimeObserver 구현하기
        timeObserver = simplePlayer.addPeriodicTimeObserver(forInterval:CMTime(seconds: 1, preferredTimescale: 10), queue: DispatchQueue.main, using: {
            time in
            self.updateTime(time: time)
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        updateTintColor()
        updateTrackInfo()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        simplePlayer.pause()
        simplePlayer.replaceCurrentItem(with: nil)
    }
    
    @IBAction func beginDrag(_ sender: UISlider) {
        isSeeking = true
    }
    
    @IBAction func endDrag(_ sender: UISlider) {
        isSeeking = false
    }
    
    @IBAction func seek(_ sender: UISlider) {
        guard let currentItem = simplePlayer.currentItem else { return }
        
        let position = Double(sender.value)
        let seconds = position * currentItem.duration.seconds
        
        simplePlayer.seek(to: CMTime(seconds: seconds, preferredTimescale: 100))
    }
    
    @IBAction func togglePlayButton(_ sender: UIButton) {
        if simplePlayer.isPlaying {
            simplePlayer.pause()
        } else {
            simplePlayer.play()
        }
        updatePlayButton()
    }

    func updatePlayButton() {
        print("bool: \(simplePlayer.isPlaying)")
        if simplePlayer.isPlaying {
            let configuration = UIImage.SymbolConfiguration(pointSize: 40)
            let image = UIImage(systemName: "pause.fill", withConfiguration: configuration)
            playControlButton.setImage(image, for: .normal)
        } else {
            let configuration = UIImage.SymbolConfiguration(pointSize: 40)
            let image = UIImage(systemName: "play.fill", withConfiguration: configuration)
            playControlButton.setImage(image, for: .normal)
        }
        
    }

}

extension PlayerViewController {
//    func updateTintColor() {
//        playControlButton.tintColor = DefaultStyle.Colors.tint
//        timeSlider.tintColor = DefaultStyle.Colors.tint
//    }
    
    func updateTrackInfo() {
        guard let track = simplePlayer.currentItem?.convertToTrack() else { return }
        thumbnailImageView.image = track.artwork
        titleLabel.text = track.title
        artistLabel.text = track.artist
    }
    
    func updateTime(time: CMTime) {
        currentTimeLabel.text = secondsToString(sec: simplePlayer.currentTime)
        totalDurationLabel.text = secondsToString(sec: simplePlayer.totalDurationTime)
        if isSeeking == false {
            timeSlider.value = Float(simplePlayer.currentTime/simplePlayer.totalDurationTime)
        }
    }
    
    func secondsToString(sec: Double) -> String {
        guard sec.isNaN == false else { return "00:00"}
        let totalSeconds = Int(sec)
        let min = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", min, seconds)
    }
}
