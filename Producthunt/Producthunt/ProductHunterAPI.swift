//
//  ProductHunterAPI.swift
//  Producthunt
//
//  Created by Павел Собянин on 28.11.2017.
//  Copyright © 2017 pavel.sobyanin. All rights reserved.
//

import Foundation

enum ProductHuntError: Error {
    case invalidJSONData
}

enum Method: String {
    case posts = "posts/all"
    case topics = "topics"
}

struct ProductHunterAPI {
    static let initialURL = "https://api.producthunt.com/v1/"
    static let access_token = "591f99547f569b05ba7d8777e2e0824eea16c440292cce1f8dfb3952cc9937ff"
    
    static let defaultURL = URL(string: "https://api.producthunt.com/v1/posts/all?search[topic]=tech&access_token=591f99547f569b05ba7d8777e2e0824eea16c440292cce1f8dfb3952cc9937ff")
    
    static let topicsListURL = URL(string: "https://api.producthunt.com/v1/topics?access_token=591f99547f569b05ba7d8777e2e0824eea16c440292cce1f8dfb3952cc9937ff")
    
    static var getPosts: URL {
        return getProducthuntURL(method: .posts, parameters: ["search[topic]":"tech"]) //NEED SELECTED TOPIC THERE!!
    }
    
    static var getTopics: URL {
        return getProducthuntURL(method: .topics, parameters: [:])
    }
    
    static func getProducthuntURL(method: Method, parameters: [String:String]?) -> URL {
        
        let baseURL = initialURL + method.rawValue
        var components = URLComponents(string: baseURL)!
        var queryItems = [URLQueryItem]()
        
        let baseParameters = [
            "access_token": access_token
        ]
        
        for (key, value) in baseParameters {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
       
        if let additionalParameters = parameters {
            for (key, value) in additionalParameters {
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
        
        components.queryItems = queryItems
        
        return components.url!
    }
    
    static func products(fromJSON data: Data) -> FetchingResult {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            //print(jsonObject)
            guard
                let jsonDictionary = jsonObject as? [AnyHashable:Any],
                let postsArray = jsonDictionary["posts"] as? [[String:Any]]
                else {
                    // The JSON structure doesn't match our expectations
                    return .failure(ProductHuntError.invalidJSONData)
            }
            var parsedProducts = [Product]()
            for productJSON in postsArray {
                if let product = product(fromJSON: productJSON) {
                    parsedProducts.append(product)
                }
            }
            
            if parsedProducts.isEmpty && !postsArray.isEmpty {
                // We weren't able to parse any of the products
                // Maybe the JSON format for photos has changed
                return .failure(ProductHuntError.invalidJSONData)
            }
            return .success(parsedProducts)
        }
        catch let error {
            return .failure(error)
        }
    }
    
    private static func product(fromJSON json: [String:Any]) -> Product? {
        //print(json)
        guard
            let description = json["tagline"] as? String,
            let title = json["name"] as? String,
            let upvotes = json["votes_count"] as? Int,
            let urlString = json["redirect_url"] as? String,
            let pictureDictionary = json["screenshot_url"] as? [String:Any],
            let thumbnailDictionary = json["thumbnail"] as? [String:Any],
            
            let pictureURLString = pictureDictionary["850px"] as? String,
            let thumbnailURLString = thumbnailDictionary["image_url"] as? String
        else {
                // Don't have enough information to construct a Product
                //print("FAIL...")
                return nil
        }
        //get product, pic and thumbnail urls
        let url = URL(string: urlString)!
        let pictureURL = URL(string: pictureURLString)!
        let thumbnailURL = URL(string: thumbnailURLString)!
        
        return Product(title: title, desc: description, upvotes: upvotes, thumbnailURL: thumbnailURL, url: url, productPictureURL: pictureURL)
    }
}
