//
//  InfoViewController.swift
//  SearchAlbums
//
//  Created by Stanislav on 09.09.2020.
//  Copyright © 2020 St. Kubrik. All rights reserved.
//

import UIKit


class InfoViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    private let network = FetchAlbum()
    private var albumModel: AlbumModel! // объект, переданный с предыдущего экрана
    private var allTrack = [TrackModel]() // массив всех полученных треков
    
     
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView() // удаляю нижний сепоратор ячейки
        self.navigationItem.title = "Album info"

        fetchSongs()
    }
    
    
    private func fetchSongs() {
        self.network.fetchTrack(for: Track(albumName: albumModel.collectionName), completion: { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    // если треков нет, то показываю сообщение
                    
                    if response.results.count == 0 {
                        removeNotFoundMassege(in: self.tableView)
                        let errorMassege = "Songs not found"
                        notFoundMassege(errorMassege, in: self.tableView)
                    } else {
                        removeNotFoundMassege(in: self.tableView)
                    }
                    
                    for track in response.results {
                        // если collectionId альбома и полученного трека совпадают, то добавляю этот трек в список песен альбома
                        if self.albumModel.collectionId == track.collectionId {
                            let trackModel = TrackModel(
                                artistName: track.artistName,
                                trackName: track.trackName,
                                image60x60: track.artworkUrl60)
                            self.allTrack.append(trackModel)
                        }
                    }
                case .failure(let error):
                    print(error)
                }
                self.tableView.reloadData()
            }
        })
    }
    
    func setModel(_ model: AlbumModel) {
        self.albumModel = model
    }
}

// MARK: - Методы делегата TableViewController

extension InfoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return allTrack.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = configureCell(tableView, indexPath: indexPath)
        return cell
    }
    
}

// MARK: - Конфигурация ячеек

extension InfoViewController {
    // Конфигурация ячейки в зависимости от секции
    private func configureCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "infoAlbum", for: indexPath) as! InfoViewCell
            cell.artistLabel.text = "Artist: \(albumModel.artistName)"
            cell.albumLabel.text = albumModel.collectionName
            cell.imageAlbumLabel.loadImage(fromURL: albumModel.image100x100)
            cell.songCountLabel.text = "Songs: \(albumModel.trackCount)"
            cell.genreLabel.text = "Genre: \(albumModel.primaryGenreName)"
            cell.releaseDateLabel.text = "Release: \(convertDateFormat(inputDate: albumModel.releaseDate))"
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "trackCount", for: indexPath) as! TrackViewCell
        cell.numberLabel.text = "\(indexPath.row + 1)."
        cell.artistLabel.text = allTrack[indexPath.row].artistName
        cell.trackNameLabel.text = allTrack[indexPath.row].trackName
        let link = allTrack[indexPath.row].image60x60
        cell.imageLabel.loadImage(fromURL: link)
        return cell
    }
}
