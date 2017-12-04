//
//  PostCell.swift
//  Producthunt
//
//  Created by Павел Собянин on 30.11.2017.
//  Copyright © 2017 pavel.sobyanin. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    @IBOutlet var postTitle: UILabel!
    @IBOutlet var descriptionTitle: UILabel!
    @IBOutlet var thumbnail: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        postTitle.adjustsFontForContentSizeCategory = true
        descriptionTitle.adjustsFontForContentSizeCategory = true
        //thumbnail.adjustsFontForContentSizeCategory = true
    }
}
