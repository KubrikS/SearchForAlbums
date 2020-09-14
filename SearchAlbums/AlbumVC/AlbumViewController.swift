//
//  ViewController.swift
//  SearchAlbums
//
//  Created by Stanislav on 08.09.2020.
//  Copyright © 2020 St. Kubrik. All rights reserved.
//

import UIKit

class AlbumViewController: UIViewController, UISearchBarDelegate {
    private let searchController = UISearchController(searchResultsController: nil)
    @IBOutlet var collectionView: UICollectionView!
    private let network = FetchAlbum()
    private var albums = [AlbumModel]()
    private var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegate()
        setNavigation()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    // метод перемещения вью на высоту клавиатуры
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardValue = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let keyboardViewEndFrame = view.convert(keyboardValue, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            collectionView.contentInset = .zero
        } else {
            collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        collectionView.scrollIndicatorInsets = collectionView.contentInset
    }
    
    // возврат высоты к первоначальному состоянию
    @objc func keyboardWillHide(notification: NSNotification) {
        if view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // если количество символов в текстфилде = 0, то удаляю все объекты из массива альбомов
        // если символы есть, то делаю запрос на сервер
        if searchBar.text?.count == 0 {
            self.albums.removeAll()
            DispatchQueue.main.async {
                removeNotFoundMassege(in: self.view)
                self.collectionView.reloadData()
            }
        } else {
            // очистка массива альбомов перед каждым запросом на сервер
            self.albums.removeAll()
            timer.invalidate() // обнуление таймера
            // запрос отправляентся через секунду после ввода текста
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { _ in
                self.network.fetchAlbum(for: Album(albumName: searchBar.text!), completion: { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let response):
                            
                            // если количество результатов = 0 и в текстфилде есть символы, то
                            // показываю сообщение об отсутствии результатов
                            if response.results.count == 0 && searchBar.text?.count != 0 {
                                removeNotFoundMassege(in: self.collectionView)
                                let errorMassege = "Nothing found for \(searchBar.text!)"
                                notFoundMassege(errorMassege, in: self.collectionView)
                            } else {
                                removeNotFoundMassege(in: self.collectionView)
                            }
                            
                            for album in response.results {
                                let albumModel = AlbumModel(
                                    artistId: album.artistId,
                                    collectionId: album.collectionId,
                                    artistName: album.artistName,
                                    collectionName: album.collectionName,
                                    image100x100: album.artworkUrl100,
                                    releaseDate: album.releaseDate,
                                    trackCount: album.trackCount,
                                    primaryGenreName: album.primaryGenreName)
                                self.albums.append(albumModel)
                            }
                            // сортировка альбомов по алфавиту
                            self.albums.sort(by: {one, two in one.collectionName < two.collectionName})
                        case .failure(let error):
                            print(error)
                        }
                        self.collectionView.reloadData()
                    }
                })
            })
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.albums.removeAll() // удаление всех объектов из массива с альбомами
        DispatchQueue.main.async {
            removeNotFoundMassege(in: self.view) // удаление вью с сообщением из иерархии
            self.collectionView.reloadData()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // индекс текущей ячейки
        guard let indexPath = collectionView.indexPathsForSelectedItems?.first else { return }
        let model = albums[indexPath.row]
        // при переходе на экран с информацией передаю модель альбома
        if let infoVC = segue.destination as? InfoViewController {
            infoVC.setModel(model)
        }
    }
    
    private func setNavigation() {
        searchController.searchBar.placeholder = "Search Albums"
        searchController.obscuresBackgroundDuringPresentation = false
        self.navigationItem.title = "Albums"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.searchController = searchController
    }
    
    private func setDelegate() {
        collectionView.delegate = self
        collectionView.dataSource = self
        searchController.searchBar.delegate = self
    }
}


extension AlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "albumCell", for: indexPath) as! AlbumsViewCell
        let link = albums[indexPath.row].image100x100
        
        cell.imageAlbumLabel.loadImage(fromURL: link)
        cell.nameAlbumLabel.text = albums[indexPath.row].collectionName
        cell.nameArtistLabel.text = albums[indexPath.row].artistName
        return cell
    }
}






