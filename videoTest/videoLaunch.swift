//
//  videoLaunch.swift
//  videoTest
//
//  Created by G Azam on 5/13/17.
//  Copyright © 2017 Rumy. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import AVKit

class VideoPlayerView: UIView {
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.startAnimating()
        return aiv
    }()
    
    let controlsContainerView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 1)
        return view
    }()
    
    lazy var pausePlayButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        let image = UIImage(named: "pause")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.addTarget(self, action: #selector(handlePause), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    
    var isPlaying = false
    
    @objc func handlePause(){
        if isPlaying{
            player?.pause()
            pausePlayButton.setImage(UIImage(named: "play"), for: .normal)
        }else{
            player?.play()
            pausePlayButton.setImage(UIImage(named: "pause"), for: .normal)
        }
        isPlaying = !isPlaying
    }
    
    
    lazy var dropDownButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        let image = UIImage(named: "down")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.addTarget(self, action: #selector(dropDown), for: .touchUpInside)
        return button
    }()
    
    var isDropDown = false
    
    
    @objc func dropDown(){
        guard let mainView = self.superview as? videoLaunch else{
            return
        }
       if isDropDown{
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            mainView.frame = (UIApplication.shared.keyWindow?.frame)!
            mainView.gestureRecognizers?.removeAll()
            }, completion: { (completedAnimation) in
        })
        dropDownButton.setImage(UIImage(named: "down"), for: .normal)
       }else{
            UIView.animate(withDuration: 0.5, animations: { 
                let height = (UIApplication.shared.keyWindow?.frame.width)! * 9 / 16
                mainView.frame = CGRect(x: 50 , y: (UIApplication.shared.keyWindow?.frame.height)! - height, width: (UIApplication.shared.keyWindow?.frame.width)! - 50, height: height)
                let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipes(_:)))
                leftSwipe.direction = .left
                mainView.addGestureRecognizer(leftSwipe)
            })
            dropDownButton.setImage(UIImage(named: "up"), for: .normal)
        }
        isDropDown = !isDropDown
    }
    
    // MARK : handle gesture
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer)
    {
        if let keyWindow = UIApplication.shared.keyWindow{
            if let playerView = keyWindow.viewWithTag(100) as? videoLaunch{
                playerView.removeFromSuperview()
                if self.player!.isPlaying{
                    self.player?.pause()
                }
            }
        }
    }
    
    
    
    let videoLengthLable: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "00:00"
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textAlignment = .right
        return label
    }()
    
    let currentTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "00:00"
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()
    
    lazy var videoSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumTrackTintColor = .red
        slider.maximumTrackTintColor = .white
        slider.setThumbImage(UIImage(named: "red"), for: .normal)
        slider.addTarget(self, action: #selector(handleSliderchange), for: .valueChanged)
        return slider
    }()
    
    @objc func handleSliderchange(){
        print(videoSlider.value)
        
        if let duration = player?.currentItem?.duration{
            let totalSeconds = CMTimeGetSeconds(duration)
            let value  = Float64(videoSlider.value) * totalSeconds
            
            let seekTime = CMTime(value: Int64(value), timescale: 1)
            player?.seek(to: seekTime, completionHandler: { (completedSeek) in
                
            })
        
        }
        
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        setupPlayerView()
        setupGradientLayer()
        controlsContainerView.frame = frame
        addSubview(controlsContainerView)
        
        // activityIndicatorview constants
        
        controlsContainerView.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        // pauseplay button constants
        
        controlsContainerView.addSubview(pausePlayButton)
        pausePlayButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        pausePlayButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        pausePlayButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        pausePlayButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // drop down button constants
        controlsContainerView.addSubview(dropDownButton)
        controlsContainerView.addConstraint(NSLayoutConstraint(item: dropDownButton, attribute: .top, relatedBy: .equal, toItem: controlsContainerView, attribute: .top, multiplier: 1, constant: 10))
        
        dropDownButton.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        
        // video length label
        controlsContainerView.addSubview(videoLengthLable)
        videoLengthLable.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        videoLengthLable.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2).isActive = true
        videoLengthLable.widthAnchor.constraint(equalToConstant: 50).isActive = true
        videoLengthLable.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        // current time lable
        controlsContainerView.addSubview(currentTimeLabel)
        currentTimeLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        currentTimeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2).isActive = true
        currentTimeLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        currentTimeLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        
        // video slider
        controlsContainerView.addSubview(videoSlider)
        videoSlider.rightAnchor.constraint(equalTo: videoLengthLable.leftAnchor).isActive = true
        videoSlider.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        videoSlider.leftAnchor.constraint(equalTo: currentTimeLabel.rightAnchor).isActive = true
        videoSlider.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        backgroundColor = UIColor.black
        
    }
    
    var player : AVPlayer?
    
    func setupPlayerView(){
        let urlString = "http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"
        if let url = URL(string: urlString){
            player = AVPlayer(url: url)
            let playerLayer = AVPlayerLayer(player: player)
            self.layer.addSublayer(playerLayer)
            playerLayer.frame = self.frame
            
            player?.play()
            player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
            
            // updating the current video duration time and update it to label
            
            let interval = CMTime(value: 1, timescale: 2)
            player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { (prograssTime) in
                let seconds = CMTimeGetSeconds(prograssTime)
                let minutesText = String(format: "%02d", Int(seconds) / 60)
                let secondsText = String(format: "%02d", Int(seconds) % 60)
                self.currentTimeLabel.text = "\(minutesText):\(secondsText)"
                
                // updating the slider 
                if let duration = self.player?.currentItem?.duration{
                    let durationSeconds = CMTimeGetSeconds(duration)
                    self.videoSlider.value = Float(seconds / durationSeconds)
                }
                
            })
        }
    
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "currentItem.loadedTimeRanges" {
            activityIndicatorView.stopAnimating()
            controlsContainerView.backgroundColor = .clear
            pausePlayButton.isHidden = false
            isPlaying = true
            
            if let duration = player?.currentItem?.duration {
                let seconds = CMTimeGetSeconds(duration)
                let secondsText = Int(seconds) % 60
                let minutesText = String(format: "%02d", Int(seconds) / 60)
                videoLengthLable.text = "\(minutesText):\(secondsText)"
            
            }
            
        }
    }
    
    
    private func setupGradientLayer(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.7, 1.2]
        controlsContainerView.layer.addSublayer(gradientLayer)
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//var tem = UIView()
//var view = UIView()
//var mainView = UIView()

class videoLaunch: UIView {
    var videoPlayerView: VideoPlayerView? = nil
    func showVideoPlayer(){
        if let keyWindow = UIApplication.shared.keyWindow{
            //self.frame = keyWindow.frame
            self.backgroundColor = UIColor.black
            self.frame = CGRect(x: keyWindow.frame.width - 10, y: keyWindow.frame.height - 10, width: 10, height: 10)
            
            let height = keyWindow.frame.width * 9 / 16
            let videoPlayerFrame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
            videoPlayerView = VideoPlayerView(frame: videoPlayerFrame)
            
            self.addSubview(videoPlayerView!)
            
            self.tag = 100
            keyWindow.addSubview(self)
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: { 
                self.frame = keyWindow.frame
                }, completion: { (completedAnimation) in
            })
        }
    }
    
    func distroy() {
       // self.videoPlayerView!.player?.isPlaying{
            self.videoPlayerView = nil
        //}
    }
}






























