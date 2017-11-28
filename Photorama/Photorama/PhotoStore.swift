//
//  Photorama.swift
//  Photorama
//
//  Created by Павел Собянин on 16.11.17.
//  Copyright © 2017 pavel.sobyanin. All rights reserved.
//

import Foundation

enum PhotoResult {
    case success([Photo])
    case failure(Error)
}

class PhotoStore {
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    func fetchInterestingPhotos(completion: @escaping (PhotoResult) -> Void) {
        let url = FlickrAPI.interestingPhotosURL
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in
            /* if let jsonData = data {
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
                    print(jsonObject)
                }
                catch let error {
                    print("Error creating JSON object: \(error)")
                }
            } else if let requestError = error {
                print("Error fetching interesting photos: \(requestError)")
            } else {
                print("Unexpected error with the request")
            }*/
            let result = self.proccessPhotosRequest(data: data, error: error)
            completion(result)
        }
        task.resume()
    }
    
    private func proccessPhotosRequest(data: Data?, error: Error?) -> PhotoResult {
        guard let jsonData = data
            else {
                return .failure(error!)
            }
        return FlickrAPI.photos(fromJSON: jsonData)
    }
}
