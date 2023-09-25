//
//  User.swift
//  Instagram
//
//  Created by 임재현 on 2023/09/14.
//

import Foundation

struct User {
    let name: String
    let profileImageURL: String
}

extension User {
    static func createRandom() -> User {
        let names = ["임재현","김철수","이나영","원빈","공유"]
        
        let profileImage = [
            "https://img.lovepik.com/photo/50146/2489.jpg_wh860.jpg"
            ,"https://live.staticflickr.com/8133/30003917960_f58619f2ae_b.jpg"
        ]
        
        return User(name: names.randomElement()!, profileImageURL: profileImage.randomElement()!)
        
    }
}
