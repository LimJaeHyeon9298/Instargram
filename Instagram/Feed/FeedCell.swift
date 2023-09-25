//
//  FeedCell.swift
//  Instagram
//
//  Created by 임재현 on 2023/09/14.
//

import Foundation
import UIKit
import AVKit

protocol FeedCellDelegate: AnyObject {
    func feedCell(_ cell: FeedCell, toggleLike feed: Feed)
    func feedCell(_ cell: FeedCell, selectUser user: User)
    func feedCellShoudExpand(_ cell: FeedCell)
}

class FeedCell: UITableViewCell {
    var feed: Feed? {
        didSet {
            guard let feed = feed, feed != oldValue  else { return }
            
            if let url = URL(string: feed.user.profileImageURL) {
                userPhotoView.setImage(url: url)
            }
            
            collectionView.reloadData()
            collectionView.contentOffset = .zero
            
            contentLabel.text = feed.content
            userNameLabel.text = feed.user.name
            
            updateLike(feed)
            
            pageControl.numberOfPages = feed.medias.count
            pageControl.currentPage = 0
            
            
            let content = "\(feed.user.name) \(feed.content)"
            let more = "... 더보기"
            let text = NSMutableAttributedString(string: content)
            let hasMore = content.hasSuffix(more)
            
            text.addAttribute(.font, value: UIFont.systemFont(ofSize: 13, weight: .regular), range: NSRange(location: 0, length: content.count))
            text.addAttribute(.font, value: UIFont.systemFont(ofSize: 13, weight: .bold), range: NSRange(location: 0, length: feed.user.name.count))
            
            if hasMore {
                text.addAttribute(.foregroundColor, value: UIColor.lightGray, range: NSRange.init(location: content.count - more.count, length: more.count))
            }
            
            
            contentLabel.attributedText = text
            
        }
    }
    
    weak var delegate: FeedCellDelegate?
    
    @IBOutlet weak private var userPhotoView: UIImageView!
    @IBOutlet weak private var userNameLabel: UILabel!
    @IBOutlet weak private var contentLabel: UILabel!
    @IBOutlet weak private var likeView: UIView!
    @IBOutlet weak private var likeButton: UIButton!
    @IBOutlet weak private var likeCountLabel: UILabel!
    @IBOutlet weak private var container: UIView!
    @IBOutlet weak private var pageControl: UIPageControl!
    @IBOutlet weak private var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.userPhotoView.makeCircle()
        self.initialize()
        self.addLikeDoubleTap()
        
        let textTap = UITapGestureRecognizer(target: self, action: #selector(selectText))
        contentLabel.addGestureRecognizer(textTap)
        contentLabel.isUserInteractionEnabled = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.initialize()
    }
    
    private func initialize() {
        self.likeView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        self.likeView.alpha = 0
    }
    
    func updateLike(_ feed: Feed) {
        likeCountLabel.text = "좋아요 \(feed.likeCount)개"
        likeButton.isSelected = feed.liked
        likeButton.tintColor = feed.liked ? .systemPink : .black
    }
}

// MARK: - FeedCellDelegate

extension FeedCell {
    @objc func selectText() {
        guard let content = feed?.content, content.count >= 40 else {
            return
        }
        delegate?.feedCellShoudExpand(self)
    }
    
    @IBAction func toggleLike() {
        guard let feed = feed else { return }
        delegate?.feedCell(self, toggleLike: feed)
    }
    
    @IBAction func selectProfile() {
        guard let user = self.feed?.user else { return }
        delegate?.feedCell(self, selectUser: user)
    }
}

// MARK: - 좋아요

extension FeedCell {
    func addLikeDoubleTap() {
        let feedDoubleTap = UITapGestureRecognizer(target: self, action: #selector(animateLike))
        feedDoubleTap.numberOfTapsRequired = 2
        container.addGestureRecognizer(feedDoubleTap)
    }
    
    
    @objc func animateLike() {
        if let feed = self.feed, feed.liked == false {
            delegate?.feedCell(self, toggleLike: feed)
        }
        
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations: {
            self.likeView.alpha = 1
            self.likeView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.likeButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }, completion: { _ in
            UIView.animate(withDuration: 0.2, delay: 0.5, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations: {
                self.likeView.alpha = 0
                self.likeView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                self.likeButton.transform = .identity
            }, completion: nil)
        })
    }
}

extension FeedCell: MoviePlayable {
    func isPlayable(from superview: UIScrollView) -> Bool {
        let intersection = superview.bounds.intersection(self.frame)
        return intersection.height > self.frame.height * 0.7
    }
    
    func pause() {
        let cells = self.collectionView.visibleCells.compactMap{$0 as? MoviePlayable}
        cells.forEach{$0.pause()}
    }
    
    func resume() {
        let cell = self.collectionView.visibleCells.compactMap{$0 as? MoviePlayable}.first
        cell?.resume()
    }
}

extension FeedCell: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = index
        
        let cells = collectionView.visibleCells
        for cell in cells {
            if let cell = cell as? MoviePlayable {
                self.bounds.intersects(cell.bounds)
            }
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let cells = collectionView.visibleCells.compactMap{$0 as? MoviePlayable}
        
        for cell in cells {
            let intersection = collectionView.bounds.intersection(cell.frame)
            if intersection.width > collectionView.frame.width * 0.5 {
                cell.resume()
            } else {
                cell.pause()
            }
        }
    }
}

extension FeedCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let media = feed?.medias[indexPath.item]
        
        if media?.type == .movie {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedMovieCell", for: indexPath) as! FeedMovieCell
            if let urlString = media?.url, let url = URL(string: urlString) {
                let item = AVPlayerItem(url: url)
                cell.player.replaceCurrentItem(with: item)
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedImageCell", for: indexPath) as! FeedImageCell
            if let urlString = media?.url, let url = URL(string: urlString) {
                cell.url = url
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        feed?.medias.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? MoviePlayable {
            cell.pause()
        }
    }
}
