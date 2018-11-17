//
//  Sonarr.swift
//  SwiftSonarr
//
//  Created by Eric Castillo on 11/13/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import Foundation

let apiHost = "http://192.168.1.15:8989"

public struct Sonarr {
    
    static func handle<T: Decodable>(result: Result<Any>, expectedResultType: T.Type, completionHandler: (Result<Any>) -> Void) {
        switch result {
        case .success(let data):
            self.handleSuccessfulAPICall(for: data, expectedResultType: expectedResultType, completionHandler: completionHandler)
        case .failure(let error):
            self.handleFailedAPICall(for: error, completionHandler: completionHandler)
        }
    }
    
    static func handleSuccessfulAPICall<T: Decodable>(for data: Any, expectedResultType: T.Type, completionHandler: (Result<Any>) -> Void) {
        guard let json = try? JSONDecoder().decode(expectedResultType, from: data as! Data) else {
            //guard let json = try? JSONSerialization.jsonObject(with: data as! Data, options: []) as! [String : Any] else {
            let error = HttpStatus.badJSON
            handleFailedAPICall(for: error, completionHandler: completionHandler)
            return
        }
        completionHandler(Result.success(json))
    }
    
    static func handleFailedAPICall(for error: Error, completionHandler: (Result<Any>) -> Void) {
        completionHandler(Result.failure(error))
    }
}
