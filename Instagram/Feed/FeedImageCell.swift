//
//  FeedImageCell.swift
//  Instagram
//
//  Created by 임재현 on 2023/09/15.
//

import Foundation
import UIKit

class FeedImageCell: UICollectionViewCell {
    var url: URL! {
        didSet {
            imageView.setImage(url: url)
        }
    }
    @IBOutlet weak private var imageView: UIImageView!
}
