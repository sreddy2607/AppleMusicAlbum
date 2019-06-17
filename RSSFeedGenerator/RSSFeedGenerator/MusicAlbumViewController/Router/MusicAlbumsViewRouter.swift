//
//  MusicAlbumsViewRouter.swift
//  RSSFeedGenerator
//
//  Created by Santhosh Reddy on 6/16/19.
//  Copyright © 2019 Santhosh Reddy. All rights reserved.
//

import Foundation
import UIKit

class MusicAlbumsViewRouter {
    
    let target: AnyObject
    
    init(viewController: MusicAlbumViewController) {
        target = viewController
    }
    
    func navigateToAlbumDetailViewController(selectedAlbum: MusicAlbum) {
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let albumDetailViewController = storyboard.instantiateViewController(withIdentifier: "AlbumDetail") as! MusicAlbumDetailViewController
        albumDetailViewController.selectedAlbum = selectedAlbum
        target.navigationController??.pushViewController(albumDetailViewController, animated: true)
    }
    
}
