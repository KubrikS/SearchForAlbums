//
//  FetchError.swift
//  SearchAlbums
//
//  Created by Stanislav on 09.09.2020.
//  Copyright © 2020 St. Kubrik. All rights reserved.
//

import Foundation

enum FetchError: Error {
    case noHTTPResponse
    case noDataReceived
    case unacceptableStatusCode
}
