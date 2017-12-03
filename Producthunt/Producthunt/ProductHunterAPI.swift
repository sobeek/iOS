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
    case posts = "posts"
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
    
    static func getParsedData(method: Method, fromJSON data: Data) -> FetchingResult {
        switch method {
        case .topics:
            return topics(fromJSON: data)
        case .posts:
            return posts(fromJSON: data)
        default:
            return .failure(ProductHuntError.invalidJSONData)
        }
    }
    
    private static func getProducthuntURL(method: Method, parameters: [String:String]?) -> URL {
        
        let baseURL = initialURL + method.rawValue + (method.rawValue == "posts" ? "/all" : "")
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
    
    static func topics(fromJSON data: Data) -> FetchingResult {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            //print(jsonObject)
            guard
                let jsonDictionary = jsonObject as? [AnyHashable:Any],
                let topicsArray = jsonDictionary["topics"] as? [[String:Any]]
                else {
                    // The JSON structure doesn't match our expectations
                    return .failure(ProductHuntError.invalidJSONData)
            }
            var parsedTopics = [Topic]()
            for productJSON in topicsArray {
                if let topic = topic(fromJSON: productJSON) {
                    parsedTopics.append(topic)
                }
            }
            
            if parsedTopics.isEmpty && !topicsArray.isEmpty {
                // We weren't able to parse any of the topics
                // Maybe the JSON format for photos has changed
                return .failure(ProductHuntError.invalidJSONData)
            }
            return .success(parsedTopics)
        }
        catch let error {
            return .failure(error)
        }
    }
    
    static func posts(fromJSON data: Data) -> FetchingResult {
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
            var parsedPosts = [Post]()
            for postJSON in postsArray {
                if let post = post(fromJSON: postJSON) {
                    parsedPosts.append(post)
                }
            }
            
            if parsedPosts.isEmpty && !postsArray.isEmpty {
                // We weren't able to parse any of the products
                // Maybe the JSON format for photos has changed
                return .failure(ProductHuntError.invalidJSONData)
            }
            return .success(parsedPosts)
        }
        catch let error {
            return .failure(error)
        }
    }
    
    private static func topic(fromJSON json: [String:Any]) -> Topic? {
        guard
            let id = json["id"] as? Int,
            let name = json["name"] as? String,
            let slug = json["slug"] as? String
        else {
            return nil
        }
        return Topic(id: id, name: name, slug: slug)
    }
    
    private static func post(fromJSON json: [String:Any]) -> Post? {
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
        
        return Post(title: title, desc: description, upvotes: upvotes, thumbnailURL: thumbnailURL, url: url, productPictureURL: pictureURL)
    }
}
