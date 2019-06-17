//
//  MusicAlbum.swift
//  RSSFeedGenerator
//
//  Created by Santhosh Reddy on 6/16/19.
//  Copyright © 2019 Santhosh Reddy. All rights reserved.
//

import Foundation
import UIKit

struct Feed: Decodable {
    var payload: Results?
    
    enum CodingKeys: String, CodingKey {
        case payload = "feed"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        if values.contains(.payload) {
            payload = try values.decode(Results.self, forKey: .payload)
        }
    }
}

struct Results: Decodable {
    var musicAlbum: [MusicAlbum] = []
    
    enum CodingKeys: String, CodingKey {
        case album = "results"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        musicAlbum = try values.decode([MusicAlbum].self
            , forKey: .album)
    }
}

class MusicAlbum: Decodable {
    
    let artistId: String?
    let artistName: String?
    let artistUrl: String?
    let artworkUrl100: String?
    let copyright: String?
    var genres: [Genre] = []
    var id: String?
    var kind: String?
    var name: String?
    var releaseDate: String?
    var url: String?
    var artWorkImage: UIImage?
    
    enum CodingKeys: String, CodingKey {
        case artistId = "artistId"
        case artistName = "artistName"
        case artistUrl = "artistUrl"
        case artworkUrl100 = "artworkUrl100"
        case copyright = "copyright"
        case id = "id"
        case kind = "kind"
        case name = "name"
        case releaseDate = "releaseDate"
        case url = "url"
        case genre = "genres"
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        artistId = try values.decode(String.self, forKey: .artistId)
        artistName = try values.decode(String.self, forKey: .artistName)
        artistUrl = try values.decode(String.self, forKey: .artistUrl)
        artworkUrl100 = try values.decode(String.self, forKey: .artworkUrl100)
        copyright = try values.decode(String.self, forKey: .copyright)
        id = try values.decode(String.self, forKey: .id)
        kind = try values.decode(String.self, forKey: .kind)
        name = try values.decode(String.self, forKey: .name)
        releaseDate = try values.decode(String.self, forKey: .releaseDate)
        url = try values.decode(String.self, forKey: .url)
        genres = try values.decode([Genre].self, forKey: .genre)
    }
 
    func downloadImage(completed: @escaping(UIImage?) -> ()) {
        guard artWorkImage == nil else {
            completed(artWorkImage)
            return
        }
        
        guard let thumbnailImageString = artworkUrl100, let thubnailImageURL = URL(string: thumbnailImageString) else {
            completed(nil)
            return
        }
        
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: thubnailImageURL) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async { [weak self] in
                        self?.artWorkImage = image
                        completed(self?.artWorkImage)
                    }
                }
            }
        }
    }
}
