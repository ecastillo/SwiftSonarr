//
//  SonarrClient.swift
//  SwiftSonarr
//
//  Created by Eric Castillo on 11/11/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import Foundation

/// The Reponse type from Alamofire is Any
typealias AlamofireJSONCompletionHandler = (Result<Any>) -> Void

/// Used to connect to any JSON API that is modeled by a SonarrEnspoint
enum SonarrClient {
    
    static func makeAPICall(to endPoint: SonarrEndpoint, completionHandler:@escaping AlamofireJSONCompletionHandler) {
        guard let url = URL(string: endPoint.url) else {
            print("invalid URL")
            let err = NSError(domain: "", code: -1, userInfo: nil)
            completionHandler(Result.failure(err))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = endPoint.httpMethod.rawValue
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("840696c003ef449e923ee65d52b85978", forHTTPHeaderField: "X-Api-Key")
        if let params = endPoint.parameters {
            guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else {
                print("json serialization failed")
                let err = NSError(domain: "", code: -1, userInfo: nil)
                completionHandler(Result.failure(err))
                return
            }
            request.httpBody = httpBody
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response {
                let httpUrlResponse = response as! HTTPURLResponse
                print(httpUrlResponse.statusCode)
                if let data = data {
                    if (200...299).contains(httpUrlResponse.statusCode) {
                        completionHandler(Result.success(data))
                    } else {
                        var userInfo = [String: Any]()
                        if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String: Any] {
                            userInfo = json
                        }
                        let err = NSError(domain: "", code: httpUrlResponse.statusCode, userInfo: userInfo)
                        completionHandler(Result.failure(err))
                    }
                }
            } else {
                completionHandler(Result.failure(error!))
            }
        }.resume()
    }
}
