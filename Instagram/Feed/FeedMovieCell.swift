//
//  FeedMovieCell.swift
//  Instagram
//
//  Created by 임재현 on 2023/09/15.
//

import Foundation
import UIKit
import AVKit

class FeedMovieCell: UICollectionViewCell, MoviePlayable {
    let player = AVPlayer()
    
    @IBOutlet weak private var playerView: MoviePlayerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.playerView.player = player
        self.playerView.playerLayer.videoGravity = .resizeAspectFill
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.player.replaceCurrentItem(with: nil)
    }
    
    func resume() {
        self.player.play()
    }
    
    func pause() {
        self.player.pause()
    }
    
    func isPlayable(from superview: UIScrollView) -> Bool {
        let intersection = superview.bounds.intersection(self.frame)
        return intersection.width > self.frame.width * 0.5
    }
}
