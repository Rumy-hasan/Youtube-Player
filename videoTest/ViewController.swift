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
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func playVideo(_ sender: AnyObject) {
        let a = videoLaunch()
        a.showVideoPlayer()
    }
}


























