//
//  FetchProducts.swift
//  Producthunt
//
//  Created by Павел Собянин on 28.11.2017.
//  Copyright © 2017 pavel.sobyanin. All rights reserved.
//

import Foundation

enum FetchingResult {
    case success([Product])
    case failure(Error)
}

class ProductsFetcher {
    
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    func fetchProducts(completion: @escaping (FetchingResult) -> Void) {
        let url = ProductHunterAPI.temporaryURL!
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
            let result = self.proccessProductsRequest(data: data, error: error)
            completion(result)
        }
        task.resume()
    }
    
    private func proccessProductsRequest(data: Data?, error: Error?) -> FetchingResult {
        guard let jsonData = data
            else {
                return .failure(error!)
        }
        return ProductHunterAPI.products(fromJSON: jsonData)
    }
}