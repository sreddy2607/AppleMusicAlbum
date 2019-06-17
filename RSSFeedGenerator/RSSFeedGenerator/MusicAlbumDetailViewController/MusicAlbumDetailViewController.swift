//
//  MusicAlbumDetailViewController.swift
//  RSSFeedGenerator
//
//  Created by Santhosh Reddy on 6/16/19.
//  Copyright © 2019 Santhosh Reddy. All rights reserved.
//

import Foundation
import UIKit

class MusicAlbumDetailViewController: UIViewController {
    var selectedAlbum: MusicAlbum!
    
    var artworkDetailView: UIImageView!
    var genreLabel: UILabel!
    var releaseDateLabel: UILabel!
    var copyrightLabel: UILabel!
    
    var iTunesLink: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = selectedAlbum.name
        createViews()
        createConstraints()
    }
    
    func createConstraints() {
        let viewsDict: [String: Any] = ["Artwork": artworkDetailView!, "Genre": genreLabel!, "ReleaseDate": releaseDateLabel!, "Copyright": copyrightLabel!, "iTunes": iTunesLink!]
        
        view.addConstraints([NSLayoutConstraint.init(item: artworkDetailView!, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)])
        
        view.addConstraints([NSLayoutConstraint.init(item: genreLabel!, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)])
        
        view.addConstraints([NSLayoutConstraint.init(item: releaseDateLabel!, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)])
        
        view.addConstraints([NSLayoutConstraint.init(item: copyrightLabel!, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)])
        
        view.addConstraint(NSLayoutConstraint.init(item: artworkDetailView!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200))
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[iTunes]-20-|", options: .init(rawValue: 0), metrics: nil, views: viewsDict))
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-100-[Artwork(200)]-50-[Genre]-12-[ReleaseDate]-12-[Copyright]-10@200-[iTunes(44)]-|", options: .init(rawValue: 0), metrics: nil, views: viewsDict))
    }
    
    @objc func navigateToiTunes() {
        guard let artistURLString = selectedAlbum.artistUrl, let url = URL(string: artistURLString), UIApplication.shared.canOpenURL(url) else {
            return
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    func createViews() {
        createArtworkDetailView()
        createGenreLabel()
        createReleaseDateLabel()
        createCopyrightLabel()
        createiTunesLink()
    }
    
    func createLabel() -> UILabel {
        let label = UILabel.init(frame: CGRect.zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }
    
    func createArtworkDetailView() {
        
        artworkDetailView = UIImageView(frame: CGRect.zero)
        artworkDetailView.translatesAutoresizingMaskIntoConstraints = false
        artworkDetailView.contentMode = .scaleAspectFit
        if let image = selectedAlbum.artWorkImage {
            artworkDetailView.image = image
        }
        view.addSubview(artworkDetailView)
    }
    
    func createGenreLabel() {
        genreLabel = createLabel()
        genreLabel.font = UIFont.systemFont(ofSize: 17)
        genreLabel.textColor = UIColor.darkGray
        var concatenated = ""
        
        for genre in selectedAlbum.genres {
            if let name = genre.name {
                concatenated.append(name + " ")
            }
        }
        genreLabel.text = concatenated
        
        view.addSubview(genreLabel)
    }
    
    func createReleaseDateLabel() {
        releaseDateLabel = createLabel()
        releaseDateLabel.font = UIFont.systemFont(ofSize: 15)
        releaseDateLabel.textColor = UIColor.lightGray
        releaseDateLabel.text = "Released on \(selectedAlbum.releaseDate ?? "")"
        
        view.addSubview(releaseDateLabel)
    }
    
    func createCopyrightLabel() {
        copyrightLabel = createLabel()
        copyrightLabel.font = UIFont.systemFont(ofSize: 14)
        copyrightLabel.textColor = .lightGray
        copyrightLabel.numberOfLines = 0
        copyrightLabel.preferredMaxLayoutWidth = UIScreen.main.bounds.size.width-20
        copyrightLabel.text = selectedAlbum.copyright
        
        view.addSubview(copyrightLabel)
    }
    
    func createiTunesLink() {
        iTunesLink = UIButton.init(frame: CGRect.zero)
        iTunesLink.translatesAutoresizingMaskIntoConstraints = false
        iTunesLink.setTitle("iTunes", for: .normal)
        iTunesLink.backgroundColor = UIColor.red
        iTunesLink.setTitleColor(.white, for: .normal)
        iTunesLink.addTarget(self, action: #selector(navigateToiTunes), for: .touchUpInside)
        iTunesLink.layer.cornerRadius = 4
        view.addSubview(iTunesLink)
    }
    
}
