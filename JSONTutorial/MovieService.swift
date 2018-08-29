//
//  MovieService.swift
//  JSONTutorial
//
//  Created by Zaur Giyasov on 29/08/2018.
//  Copyright © 2018 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

// conforming the protocol
struct MovieService: Gettable {
    
    let endpoint: String = "https://itunes.apple.com/ru/rss/topmovies/limit=25/json"
    
    let downloader = JSONDownloader()
    
    //the associated type is inferred by <[Movie?]>
    typealias CurrentWeatherCompletionHandler = (Result<[Movie?]>) -> ()
    
    func get(completion: @escaping CurrentWeatherCompletionHandler) {
        
        guard let url = URL(string: self.endpoint) else {
            completion(.Error(.invalidURL))
            return
        }
        
        let request = URLRequest(url: url)
        let task = downloader.jsonTask(with: request) { (result) in
            
            DispatchQueue.main.async {
                switch result {
                case .Error(let error):
                    completion(.Error(error))
                    return
                case .Success(let json):
                    guard let movieJSONFeed = json["feed"] as? [String: AnyObject], let entryArray = movieJSONFeed["entry"] as? [[String: AnyObject]] else {
                        completion(.Error(.jsonParsingFailure))
                        return
                    }
                    
                    let movieArray = entryArray.map{Movie(json: $0)}
                    completion(.Success(movieArray))
                }
            }
        }
        task.resume()
    }
}

// uisng associatedType in protocol
protocol Gettable {
    associatedtype T
    func get(completion: @escaping (Result<T>) -> Void)
}
