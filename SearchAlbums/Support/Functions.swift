//
//  Functions.swift
//  SearchAlbums
//
//  Created by Stanislav on 12.09.2020.
//  Copyright © 2020 St. Kubrik. All rights reserved.
//

import UIKit

// Сообщение об отсутсвии результатов
func notFoundMassege(_ text: String, in view: UIView) {
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 30))
    label.tag = 10
    label.center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 23.0)
    label.font = UIFont.boldSystemFont(ofSize: 20.0)
    label.textColor = .lightGray
    label.text = text
    view.addSubview(label)
}

// удаление вью с сообщением из иерархии
func removeNotFoundMassege(in view: UIView){
    if let viewWithTag = view.viewWithTag(10) {
        viewWithTag.removeFromSuperview()
    }
}

// конвертер даты релиза
func convertDateFormat(inputDate: String) -> String {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    
    let oldDate = dateFormatter.date(from: inputDate)
    
    let convertDateFormatter = DateFormatter()
    convertDateFormatter.dateFormat = "dd.MM.yyyy"
    
    return convertDateFormatter.string(from: oldDate!)
}
