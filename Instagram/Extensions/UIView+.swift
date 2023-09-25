//
//  UIView+.swift
//  Instagram
//
//  Created by 임재현 on 2023/09/14.
//

import UIKit

extension UIView {
    func makeCircle() {
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = true
    }
}
