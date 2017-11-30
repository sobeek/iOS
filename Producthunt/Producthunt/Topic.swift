//
//  Topic.swift
//  Producthunt
//
//  Created by Павел Собянин on 01.12.2017.
//  Copyright © 2017 pavel.sobyanin. All rights reserved.
//

import Foundation

class Topic {
    
    let id: Int
    let name: String
    let slug: String
    
    init(id: Int, name: String, slug: String) {
        self.id = id
        self.name = name
        self.slug = slug
    }
}

class TopicList {
    var topics = [Topic]()
}
