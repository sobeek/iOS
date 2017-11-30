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
        //let url = URL(string: "http://www.apple.com/euro/ios/ios8/a/generic/images/og.png")!
        //let view = self
        print("URL: \(url.path)")
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
