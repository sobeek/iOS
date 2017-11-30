//
//  ProductCell.swift
//  Producthunt
//
//  Created by Павел Собянин on 30.11.2017.
//  Copyright © 2017 pavel.sobyanin. All rights reserved.
//

import UIKit

class ProductCell: UITableViewCell {
    @IBOutlet var productTitle: UILabel!
    @IBOutlet var descriptionTitle: UILabel!
    @IBOutlet var thumbnail: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        productTitle.adjustsFontForContentSizeCategory = true
        descriptionTitle.adjustsFontForContentSizeCategory = true
        //thumbnail.adjustsFontForContentSizeCategory = true
    }
}
