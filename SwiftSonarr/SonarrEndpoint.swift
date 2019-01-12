//
//  SonarrEndpoint.swift
//  SwiftSonarr
//
//  Created by Eric Castillo on 11/11/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import Foundation

/// Types that conform to this model an API endpoint that can be connected to via Alamofire
protocol SonarrEndpoint {
    
    /// Provides all the information required to make the API call from Alamofire
    func provideValues() -> (path: String, httpMethod: HTTPMethod, parameters:[String:Any]?)
    
    var url: String                 { get }
    var httpMethod: HTTPMethod      { get }
    var parameters: [String: Any]?  { get }
}

extension SonarrEndpoint {
    
    var url: String                 { return apiHost + "/api/v3" + provideValues().path }
    var httpMethod: HTTPMethod      { return provideValues().httpMethod }
    var parameters: [String: Any]?  { return provideValues().parameters }
}
