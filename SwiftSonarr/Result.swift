//
//  Result.swift
//  SwiftSonarr
//
//  Created by Eric Castillo on 11/11/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import Foundation

/// The response from a method that can result in either a successful or failed state
public enum Result<T>: Any {
    case success(T)
    case failure(SSError)
}
