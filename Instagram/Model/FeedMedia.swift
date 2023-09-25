//
//  FeedMedia.swift
//  Instagram
//
//  Created by 임재현 on 2023/09/14.
//

import Foundation

enum FeedMediaType {
    case photo
    case movie
}

struct FeedMedia {
    let type: FeedMediaType
    let url: String
}

extension FeedMedia {
    static private let images = [
        "https://images.unsplash.com/photo-1593642533144-3d62aa4783ec?ixid=MnwxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=300&q=80",
        "https://images.unsplash.com/photo-1623435119185-3886f034006a?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=300&q=80",
        "https://images.unsplash.com/photo-1626639900754-78b8dddbcc37?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=300&q=80",
        "https://images.unsplash.com/photo-1553272725-086100aecf5e?ixid=MnwxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=300&q=80",
        "https://images.unsplash.com/photo-1626541672773-ed6234412f07?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=300&q=80",
        "https://images.unsplash.com/photo-1578496480157-697fc14d2e55?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=640&q=50",
        "https://images.unsplash.com/photo-1612528443702-f6741f70a049?ixid=MnwxMjA3fDB8MHxzZWFyY2h8NXx8c2FtcGxlfGVufDB8fDB8fA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=40",
        "https://images.unsplash.com/photo-1531361171768-37170e369163?ixid=MnwxMjA3fDB8MHxzZWFyY2h8OXx8c2FtcGxlfGVufDB8fDB8fA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=60",
        "https://images.unsplash.com/photo-1558389186-438424b00a32?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MjJ8fHNhbXBsZXxlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=60",
        "https://images.unsplash.com/photo-1579684288538-c76a2fab9617?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=50",
        "https://images.unsplash.com/photo-1551307090-6c32b15bd0c6?ixid=MnwxMjA3fDB8MHxzZWFyY2h8NDF8fHNhbXBsZXxlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=60",
        "https://images.unsplash.com/photo-1558383336-bd0c9e832d48?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTA3fHxzYW1wbGV8ZW58MHx8MHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=60",
        "https://images.unsplash.com/photo-1558393383-f6f7f7f9ef1c?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1yZWxhdGVkfDE2fHx8ZW58MHx8fHw%3D&auto=format&fit=crop&w=600&q=60",
        "https://images.unsplash.com/photo-1570794457138-d461b3f73ba0?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=600&q=80",
        "https://images.unsplash.com/photo-1564767710096-65b382709d09?ixid=MnwxMjA3fDB8MHxjb2xsZWN0aW9uLXBhZ2V8MTV8ODU4ODU0Mnx8ZW58MHx8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=60",
        "https://images.unsplash.com/photo-1558565785-3f89fbace6eb?ixid=MnwxMjA3fDB8MHxjb2xsZWN0aW9uLXBhZ2V8NTd8ODU4ODU0Mnx8ZW58MHx8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=60"
    ]
    
    
    static func allPhotos() -> [FeedMedia] {
        images.map{FeedMedia(type: .photo, url: $0)}
    }
    
    static func createRandom() -> FeedMedia {
        let movies = ["https://lachy.id.au/dev/markup/examples/video/bus.mp4",
                      "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4",
                      "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4"]
        
        let type = [0, 1, 2].randomElement() == 0 ? FeedMediaType.movie : FeedMediaType.photo
        let url = type == .movie ? movies.randomElement()! : images.randomElement()!
        
        return FeedMedia(type: type, url: url)
    }
}
