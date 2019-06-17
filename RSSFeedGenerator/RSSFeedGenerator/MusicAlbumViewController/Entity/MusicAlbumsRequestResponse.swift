//
//  MusicAlbumsRequestResponse.swift
//  RSSFeedGenerator
//
//  Created by Santhosh Reddy on 6/16/19.
//  Copyright © 2019 Santhosh Reddy. All rights reserved.
//

import Foundation

struct MusicAlbumsRequestObject: RequestObject {
    var url: URL
    var host: String = ""
    var path: String = ""
    var method: String = httpMethod.getMethod.rawValue
    var body: [String: Any]?
    var headers: [[String : Any]]?
    
    typealias response = MusicAlbumsResponseObject
    
    init(albumsURL: String) {
        url = URL(string: albumsURL)!
    }
    
}

struct MusicAlbumsResponseObject: ResponseObject {
    
    //var responseDictionary: [String: Any]?
    var error: SCError?
    var feed: Feed?
    
    static func parse(data: Data, success: Bool) -> MusicAlbumsResponseObject? {
        
        if success {
            var response = MusicAlbumsResponseObject()
            
            do {
                response.feed = try JSONDecoder().decode(Feed.self, from: data)
            } catch {
                print(error)
            }
            return response
        }
        else {
            var response = MusicAlbumsResponseObject()
            response.error = SCError()
            return response
        }
    }
}
