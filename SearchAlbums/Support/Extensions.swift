//
//  Extensions.swift
//  SearchAlbums
//
//  Created by Stanislav on 11.09.2020.
//  Copyright © 2020 St. Kubrik. All rights reserved.
//

import UIKit

// MARK: - Метод асинхронной загрузки картинки в ячейку

extension UIImageView {
    func loadImage(fromURL url: String) {
        guard let imageURL = URL(string: url) else { return }
        let request = URLRequest(url: imageURL)
        
        DispatchQueue.global(qos: .background).async {
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.image = image
                    }
                }
            }.resume()
        }
    }
}
