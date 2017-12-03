//
//  ProductDetailsViewController.swift
//  Producthunt
//
//  Created by Павел Собянин on 30.11.2017.
//  Copyright © 2017 pavel.sobyanin. All rights reserved.
//

import UIKit

class PostDetailsViewController: UIViewController {
    
    var post: Post! {
        didSet {
            navigationItem.title = post.title
        }
    }
    
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var upvotesNumber: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    @IBAction func getProduct (sender: UIButton) {
        UIApplication.shared.open(post.url, options: [:], completionHandler: nil)
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        descriptionLabel.text = post.desc
        upvotesNumber.text = "\(post.upvotes)"
        
        let imageDownloader = ImageDownloader()
        imageDownloader.imageDownload(url: post.productPictureURL, imageView: imageView)
    }
}

