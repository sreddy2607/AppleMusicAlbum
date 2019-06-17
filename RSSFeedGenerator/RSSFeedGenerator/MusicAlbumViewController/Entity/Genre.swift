//
//  Genre.swift
//  RSSFeedGenerator
//
//  Created by Santhosh Reddy on 6/16/19.
//  Copyright © 2019 Santhosh Reddy. All rights reserved.
//

import Foundation

struct Genre: Decodable {
    let genreId: String?
    let name: String?
    let url: String?

    enum CodingKeys: String, CodingKey {
        case genreId = "genreId"
        case name = "name"
        case url = "url"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        genreId = try values.decode(String.self, forKey: .genreId)
        name = try values.decode(String.self, forKey: .name)
        url = try values.decode(String.self, forKey: .url)
    }
    
    
}
