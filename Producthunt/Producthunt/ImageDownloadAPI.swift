//
//  ImageDownloadAPI.swift
//  Producthunt
//
//  Created by Павел Собянин on 30.11.2017.
//  Copyright © 2017 pavel.sobyanin. All rights reserved.
//

import UIKit

class ImageDownloader {
    
    func imageDownload(url: URL, imageView: UIImageView) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil
                else {
                    return
            }
            DispatchQueue.main.async() {
                imageView.image = UIImage(data: data)
            }
        }
        
        task.resume()
    }
    

}
