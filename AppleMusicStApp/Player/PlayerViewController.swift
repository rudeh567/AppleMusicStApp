//
//  PlayerViewController.swift
//  AppleMusicStApp
//
//  Created by yeoboya on 2021/10/06.
//

import UIKit
import CoreMedia

class PlayerViewController: UIViewController {

    @IBOutlet weak var thumbnailImageVIew: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    
    @IBOutlet weak var playControlButton: UIButton!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    
    var timeObserver: Any?
    var inSeeking: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updatePlayButton()
        updateTime(time: CMTime.zero)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTintColor()
        updateTrackInfo()
    }
    
    

}
