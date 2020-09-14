//
//  FetchModel.swift
//  SearchAlbums
//
//  Created by Stanislav on 09.09.2020.
//  Copyright © 2020 St. Kubrik. All rights reserved.
//

import UIKit

protocol AlbumSource {
    var urlRequest: URLRequest? { get }
}

struct Album: AlbumSource {
    var albumName: String
    
    var url: URL {
        let name = albumName.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        return URL(string: "https://itunes.apple.com/search?term=\(name ?? "")&entity=album&attribure=albumTerm")!
    }
    var urlRequest: URLRequest? {
        return URLRequest(url: url)
    }
}

struct Track: AlbumSource {
    var albumName: String
    var url: URL {
        let name = albumName.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        return URL(string: "https://itunes.apple.com/search?term=\(name ?? "")&media=music&entity=allTrack&attribute=albumTerm&limit=200")!
    }
    var urlRequest: URLRequest? {
        return URLRequest(url: url)
    }
}

struct FetchAlbum {
    let networkingService = NetworkingService()
    
    func fetchAlbum(for source: AlbumSource, completion: @escaping (Result<AlbumCodable, Error>) -> Void) {
        let request = source
        networkingService.fetch(with: request.urlRequest!, completion: completion)
    }
    
    func fetchTrack(for source: AlbumSource, completion: @escaping (Result<TrackCodable, Error>) -> Void) {
        let request = source
        networkingService.fetch(with: request.urlRequest!, completion: completion)
    }
}

