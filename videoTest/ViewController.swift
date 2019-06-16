//
//  ViewController.swift
//  videoTest
//
//  Created by G Azam on 5/13/17.
//  Copyright © 2017 Rumy. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class ViewController: UIViewController {
    
    var playerController = AVPlayerViewController()
    var player: AVPlayer?
    override func viewDidLoad() {
        super.viewDidLoad()
        let movieURL = URL(string: "http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
        if let url = movieURL {
            self.player = AVPlayer(url: url)
            self.playerController.player = self.player
        }
    }

    @IBAction func playVideo(_ sender: AnyObject) {
        let a = videoLaunch()
        a.showVideoPlayer()
    }

}


























