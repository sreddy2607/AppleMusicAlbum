//
//  MusicAlbumsViewPresenter.swift
//  RSSFeedGenerator
//
//  Created by Santhosh Reddy on 6/16/19.
//  Copyright © 2019 Santhosh Reddy. All rights reserved.
//

import Foundation

protocol MusicAlbumsViewProtocol: class {
    func musicAlbumsFetched(albums: [MusicAlbum])
}

class MusicAlbumsViewPresenter {
    
    let interactor: MusicAlbumIntaractor
    weak var delegate: MusicAlbumsViewProtocol?
    
    init(musicAlbumsInteractor: MusicAlbumIntaractor) {
        interactor = musicAlbumsInteractor
    }
    
    func fetchMusicAlbums(count: Int) {
        interactor.fetchAlbums(count: count) { [weak self] (success, error, albums) in
            if success {
                guard let albumsInfo = albums else {
                    self?.delegate?.musicAlbumsFetched(albums: [])
                    return
                }
                self?.delegate?.musicAlbumsFetched(albums: albumsInfo)
            }
            else {
                self?.delegate?.musicAlbumsFetched(albums: [])
            }
        }
    }
}
