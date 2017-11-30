//
//  ProductDetailsViewController.swift
//  Producthunt
//
//  Created by Павел Собянин on 30.11.2017.
//  Copyright © 2017 pavel.sobyanin. All rights reserved.
//

import UIKit

class ProductDetailsViewController: UIViewController {
    
    var product: Product! {
        didSet {
            navigationItem.title = product.title
        }
    }
    
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var upvotesNumber: UILabel!
    
    @IBAction func getProduct (sender: UIButton) {
        UIApplication.shared.open(product.url, options: [:], completionHandler: nil)
    }
    @IBOutlet var imageView: UIImageView!

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        descriptionLabel.text = product.desc
        upvotesNumber.text = "\(product.upvotes)"
        
        let imageDownloader = ImageDownloader()
        imageDownloader.imageDownload(url: product.productPictureURL, imageView: imageView)
    }
}

