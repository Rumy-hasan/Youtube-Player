//
//  extentions.swift
//  videoTest
//
//  Created by Paradox on 16/6/19.
//  Copyright © 2019 Rumy. All rights reserved.
//

import Foundation
import AVKit

extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}
