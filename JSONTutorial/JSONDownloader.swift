//
//  JSONDownloader.swift
//  JSONTutorial
//
//  Created by Zaur Giyasov on 29/08/2018.
//  Copyright © 2018 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

struct JSONDownloader {
    
    let session: URLSession
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    init() {
        self.init(configuration: .default)
    }
    
    typealias JSON = [String: AnyObject]
    typealias JSONTaskCompletionHandler = (Result<JSON>) -> ()
    
    // URLSessionDataTask = "jsonTask"
    func jsonTask(with request: URLRequest, compleationHandler completion: @escaping JSONTaskCompletionHandler) -> URLSessionDataTask {

        let task = session.dataTask(with: request) { (data, responce, error) in
            
            guard let httpResponse = responce as? HTTPURLResponse else {
                completion(.Error(.requestFailed))
                return
            }
            
            if httpResponse.statusCode == 200 {
                if let data = data {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] {
                            DispatchQueue.main.async {
                                completion(.Success(json))
                            }
                        }
                    } catch {
                        completion(.Error(.jsonConversionFailure))
                    }
                } else {
                    completion(.Error(.invalidData))
                }
            } else {
                completion(.Error(.responseUnsuccessful))
                print("\(String(describing: error?.localizedDescription))")
            }
        }
        return task
        
    }
    
}

enum Result <T> {
    case Success(T)
    case Error(ItunesApiError)
}

enum ItunesApiError: Error {
    case requestFailed
    case jsonConversionFailure
    case invalidData
    case responseUnsuccessful
    case invalidURL
    case jsonParsingFailure
}


