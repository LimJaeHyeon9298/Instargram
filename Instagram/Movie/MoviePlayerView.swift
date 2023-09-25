//
//  MoviePlayerView.swift
//  Instagram
//
//  Created by 임재현 on 2023/09/15.
//

import Foundation
import AVKit

class MoviePlayerView: UIView {
    override static var layerClass: AnyClass { AVPlayerLayer.self }
    
    // The associated player object.
    var player: AVPlayer? {
        get { playerLayer.player }
        set { playerLayer.player = newValue }
    }
    
    var playerLayer: AVPlayerLayer { layer as! AVPlayerLayer }
}
