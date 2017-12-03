//
//  Product.swift
//  Producthunt
//
//  Created by Павел Собянин on 27.11.2017.
//  Copyright © 2017 pavel.sobyanin. All rights reserved.
//

import UIKit

class Post: NSObject {
    /*В каждой ячейке в списке отображется следующая информация:
     Название продукта
     Описание
     Количество upvotes
     Thumbnail
 */
    /*
 Страница продукта
 На странице продукта отображается все то же самое, что и в ячейке в списке, кроме
 следующих моментов:
  Есть кнопка “Get it”, которая открывает ссылку на этот продукт;
  Вместо Thumbnail отображается скриншот продукта.
 */
    
    var title: String
    var desc: String
    var upvotes: Int
    var thumbnailURL: URL
    var url: URL
    var productPictureURL: URL
    
    init(title: String, desc: String, upvotes: Int, thumbnailURL: URL, url: URL, productPictureURL: URL) {
        self.title = title
        self.desc = desc
        self.upvotes = upvotes
        self.thumbnailURL = thumbnailURL
        self.url = url
        self.productPictureURL = productPictureURL
    }
}
