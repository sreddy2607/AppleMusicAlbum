//
//  MusicAlbumViewController.swift
//  RSSFeedGenerator
//
//  Created by Santhosh Reddy on 6/16/19.
//  Copyright © 2019 Santhosh Reddy. All rights reserved.
//

import UIKit

class MusicAlbumViewController: UIViewController {
    
    var albumsTableView: UITableView!
    var musicAlbums: [MusicAlbum] = []
    var presenter: MusicAlbumsViewPresenter?
    var router: MusicAlbumsViewRouter?
    
    func configureAlbumsTableView() {
        self.albumsTableView = UITableView.init(frame: CGRect.zero)
        self.albumsTableView.translatesAutoresizingMaskIntoConstraints = false
        self.albumsTableView.register(MusicAlbumTableViewCell.self, forCellReuseIdentifier: "Album")
        self.albumsTableView.estimatedRowHeight = 75
        self.albumsTableView.clipsToBounds = false
        self.albumsTableView.dataSource = self
        self.albumsTableView.delegate = self
        
        self.view.addSubview(albumsTableView)
    }
    
    func createTableViewConstraints() {
        
        let viewsDict: [String: Any] = ["Albums": albumsTableView!]
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[Albums]|", options: .init(rawValue: 0), metrics: nil, views: viewsDict))
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[Albums]|", options: .init(rawValue: 0), metrics: nil, views: viewsDict))
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Music albums"
        
        //Configure TableView
        configureAlbumsTableView()
        createTableViewConstraints()
        configurePresenter()
        loadAlbums()
    }
    
    func loadAlbums() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        presenter?.fetchMusicAlbums(count: 100)
    }
    
    override func loadView() {
        super.loadView()
    }
    
    func configurePresenter() {
        //Configure Interactor
        let interactor = MusicAlbumIntaractor()
        
        //Configure Presenter
        presenter = MusicAlbumsViewPresenter(musicAlbumsInteractor: interactor)
        presenter!.delegate = self
        
        //Configure Router
        router = MusicAlbumsViewRouter(viewController: self)
    }
    
}

extension MusicAlbumViewController: MusicAlbumsViewProtocol {
    func musicAlbumsFetched(albums: [MusicAlbum]) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        self.musicAlbums = albums
        self.albumsTableView?.reloadData()
    }
}

extension MusicAlbumViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicAlbums.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Album") as? MusicAlbumTableViewCell else {
            return UITableViewCell()
        }
        
        cell.createViews()
        cell.createConstraints()
        
        let album = musicAlbums[indexPath.row]
        cell.configureCell(album: album)
        
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    
}

extension MusicAlbumViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedAlbum = musicAlbums[indexPath.row]
        router?.navigateToAlbumDetailViewController(selectedAlbum: selectedAlbum)
    }
    
}
