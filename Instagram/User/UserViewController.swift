//
//  UserViewController.swift
//  Instagram
//
//  Created by 임재현 on 2023/09/15.
//
import Foundation
import UIKit

class UserProfileCell: UICollectionReusableView {
    var user: User? {
        didSet {
            guard let profileImageUrl = user?.profileImageURL, let url = URL(string: profileImageUrl) else {
                photoView.image = nil
                nameLabel.text = "-"
                return
            }
            
            photoView.setImage(url: url)
            nameLabel.text = user?.name
        }
    }
    
    @IBOutlet weak private var photoView: UIImageView!
    @IBOutlet weak private var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.photoView.makeCircle()
    }
}


class UserFeedCell: UICollectionViewCell {
    var profileImage: String? {
        didSet {
            if let profileImage = profileImage, let url = URL(string: profileImage) {
                self.photoView.setImage(url: url)
            } else {
                self.photoView.image = nil
            }
        }
    }
    
    @IBOutlet weak private var photoView: UIImageView!
}

class UserViewController: UIViewController {
    var user: User?
    var medias: [FeedMedia] = {
        FeedMedia.allPhotos().shuffled()
    }()
}

extension UserViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        medias.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserFeedCell", for: indexPath) as! UserFeedCell
        cell.profileImage = medias[indexPath.item].url
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "UserProfileCell", for: indexPath) as! UserProfileCell
        view.user = user
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 220)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.frame.width - 2) / 3
        return CGSize(width: size, height: size)
    }
}
