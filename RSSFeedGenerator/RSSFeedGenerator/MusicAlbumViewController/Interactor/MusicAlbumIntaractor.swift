//
//  MusicAlbumIntaractor.swift
//  RSSFeedGenerator
//
//  Created by Santhosh Reddy on 6/16/19.
//  Copyright © 2019 Santhosh Reddy. All rights reserved.
//

import Foundation

fileprivate var albumsURL = "https://rss.itunes.apple.com/api/v1/us/apple-music/coming-soon/all/%@/explicit.json"

class MusicAlbumIntaractor {
    func fetchAlbums(count: Int, completion: @escaping(Bool, SCError?, [MusicAlbum]?) -> ()) {
        let url = String(format: albumsURL, "\(count)")
        let request = MusicAlbumsRequestObject.init(albumsURL: url)
        
        NetworkManager().send(r: request) { (success, response, error) in
            if success {
                guard let feed = response?.feed , let results = feed.payload else {
                    completion(success, error, nil)
                    return
                }
                completion(success, nil, results.musicAlbum)
            }
            else {
                completion(success, error, nil)
            }
        }
    }
}
