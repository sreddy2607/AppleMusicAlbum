//
//  MusicAlbumTableViewCell.swift
//  RSSFeedGenerator
//
//  Created by Santhosh Reddy on 6/16/19.
//  Copyright © 2019 Santhosh Reddy. All rights reserved.
//

import UIKit

class MusicAlbumTableViewCell: UITableViewCell {
    
    var albumName: UILabel!
    var artistName: UILabel!
    var albumImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(album: MusicAlbum) {
        albumName.text = album.name
        artistName.text = album.artistName
        
        album.downloadImage { [weak self] (downloadedImage) in
            self?.albumImageView.image = downloadedImage
        }
    }
    
    func createLabel() -> UILabel {
        let label = UILabel.init(frame: CGRect.zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func createViews() {
        if albumName == nil {
            albumName = createLabel()
            albumName.textColor = .darkGray
            albumName.font = .boldSystemFont(ofSize: 16)
            albumName.numberOfLines = 2
        }
        addSubview(albumName)
        
        if artistName == nil {
            artistName = createLabel()
            artistName.textColor = .lightGray
            artistName.font = .systemFont(ofSize: 14)
        }
        addSubview(artistName)
        
        if albumImageView == nil {
            albumImageView = UIImageView(frame: CGRect.zero)
            albumImageView.translatesAutoresizingMaskIntoConstraints = false
        }
        addSubview(albumImageView)
    }
    
    func createConstraints() {
        
        guard albumName != nil, artistName != nil, albumImageView != nil else {
            return
        }
        
        let viewsDict: [String: Any] = ["AlbumName": albumName!, "ArtistName": artistName!, "AlbumImage": albumImageView!]
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[AlbumImage(50)]-10-|", options: .init(rawValue: 0), metrics: nil, views: viewsDict))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[AlbumImage(50)]-10-[AlbumName]-16-|", options: .init(rawValue: 0), metrics: nil, views: viewsDict))
        
        addConstraint(NSLayoutConstraint.init(item: albumName!, attribute: .top, relatedBy: .equal, toItem: albumImageView, attribute: .top, multiplier: 1, constant: 0))
        
        addConstraint(NSLayoutConstraint.init(item: artistName!, attribute: .top, relatedBy: .equal, toItem: albumName, attribute: .bottom, multiplier: 1, constant: 0))
        
        addConstraint(NSLayoutConstraint.init(item: artistName!, attribute: .leading, relatedBy: .equal, toItem: albumName, attribute: .leading, multiplier: 1, constant: 0))
    }

}
