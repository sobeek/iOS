//
//  ItemStore.swift
//  Homepwner
//
//  Created by Павел Собянин on 08.10.17.
//  Copyright © 2017 pavel.sobyanin. All rights reserved.
//

import UIKit

class ItemStore {
    var allItems: [[Item]] = [[], []]
    //var arr: [[Int]] = []
    
    @discardableResult func createItem() -> Item {
        let newItem = Item(random: true)
        
        if (newItem.valueInDollars < 50) {
            allItems[0].append(newItem)
        }
        else {
            //if let nextSection = allItems[1]
            allItems[1].append(newItem)
        }
        //allItems.append(newItem)
        return newItem
    }
    
    init() {
        for _ in 0..<5 {
            createItem()
        }
        
        //let endingCell = TableViewEndingCell()
        //allItems.append([endingCell])
        
        //let endingItem = Item(name: "No more items!", serialNumber: nil, valueInDollars: 0)
        //allItems.append([endingItem])
    }
}
