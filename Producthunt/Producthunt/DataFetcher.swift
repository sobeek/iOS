//
//  DataFetcher.swift
//  Producthunt
//
//  Created by Павел Собянин on 28.11.2017.
//  Copyright © 2017 pavel.sobyanin. All rights reserved.
//

import Foundation

enum FetchingResult {
    case success([Any])
    case failure(Error)
}

class DataFetcher {
    
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    func fetch(method: Method, url: URL, completion: @escaping (FetchingResult) -> Void) {
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in
            let result = self.proccessDataRequest(method: method, data: data, error: error)
            completion(result)
        }
        task.resume()
    }
    
    private func proccessDataRequest(method: Method, data: Data?, error: Error?) -> FetchingResult {
        guard let jsonData = data
            else {
                return .failure(error!)
        }
        return ProductHunterAPI.getParsedData(method: method, fromJSON: jsonData)
    }
}
