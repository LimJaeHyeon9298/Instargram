//
//  UIImageView+.swift
//  Instagram
//
//  Created by 임재현 on 2023/09/14.
//

import Foundation
import UIKit
import AlamofireImage

extension UIImageView {
    func setImage(url: URL) {
        self.af.setImage(withURL: url, progressQueue: DispatchQueue.main, imageTransition: .crossDissolve(0.2), runImageTransitionIfCached: false, completion: { response in
            if let error = response.error {
                print(error)
            }
        })
    }
}
