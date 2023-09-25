//
//  MoviePlayable.swift
//  Instagram
//
//  Created by 임재현 on 2023/09/15.
//

import Foundation
import UIKit

protocol MoviePlayable: UIView {
    func isPlayable(from superview: UIScrollView) -> Bool
    func resume()
    func pause()
}
