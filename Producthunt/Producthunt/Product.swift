//
//  Product.swift
//  Producthunt
//
//  Created by Павел Собянин on 27.11.2017.
//  Copyright © 2017 pavel.sobyanin. All rights reserved.
//

import UIKit

class Product: NSObject {
    /*В каждой ячейке в списке отображется следующая информация:
     Название продукта
     Описание
     Количество upvotes
     Thumbnail
 */
    var name: String
    var desc: String
    var upvotes: Int
    var thumbnail: UIImage
    
    init(name: String, desc: String, upvotes: Int, thumbnail: UIImage) {
        self.name = name
        self.desc = desc
        self.upvotes = upvotes
        self.thumbnail = thumbnail
    }
}
