//
//  CodableModel.swift
//  SearchAlbums
//
//  Created by Stanislav on 09.09.2020.
//  Copyright © 2020 St. Kubrik. All rights reserved.
//

import UIKit

// MARK: - AlbumCodable

struct AlbumCodable: Codable {
    let results: [AlbumResult]
}

struct AlbumResult: Codable {
    let artistId: Int
    let collectionId: Int
    let artistName: String
    let collectionName: String
    let artworkUrl100: String
    let releaseDate: String
    let trackCount: Int
    let primaryGenreName: String
}


// MARK: - TrackCodable

struct TrackCodable: Codable {
    let results: [TrackResult]
}

struct TrackResult: Codable {
    let collectionId: Int
    let artistName: String
    let trackName: String
    let artworkUrl60: String
}
