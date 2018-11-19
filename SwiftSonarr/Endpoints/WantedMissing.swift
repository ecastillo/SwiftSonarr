//
//  WantedMissing.swift
//  SwiftSonarr
//
//  Created by Eric Castillo on 11/18/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import Foundation

public struct WantedMissing: Codable {
    public var page: Int?
    public var pageSize: Int?
    public var sortKey: SortKey?
    public var sortDirection: SortDirection?
    public var totalRecords: Int?
    public let records: [Episode]?
    
    public enum SortKey: String, Codable {
        case seriesTitle = "series.title"
        case airDateUtc = "airDateUtc"
    }
    
    public enum SortDirection: String, Codable {
        case ascending = "ascending"
        case descending = "descending"
    }
    
    public struct Options: Codable {
        public init() {}
        
        public var sortKey: WantedMissing.SortKey?
        public var page: Int?
        public var pageSize: Int?
        public var sortDir: WantedMissing.SortDirection?
    }
}



/// Models the Wanted Missing endpoint from the Sonarr API.
enum WantedMissingEndpoint: SonarrEndpoint {
    
    case wantedMissing(options: WantedMissing.Options?)
    
    // MARK: - SonarrEndpoint conforming methods
    
    func provideValues() -> (path: String, httpMethod: HTTPMethod, parameters:[String:Any]?) {
        switch self {
        case .wantedMissing(let options):
            let params = parameters(options: options)
            return (path: "/wanted/missing", httpMethod: .get, parameters: params)
        }
    }
    
    private func parameters(options: WantedMissing.Options?) -> [String : Any] {
        guard let options = options, let params = try! JSONSerialization.jsonObject(with: JSONEncoder().encode(options)) as? [String: Any] else {
            return [:]
        }
        return params
    }
}

public extension Sonarr {
    
    public static func wantedMissing(options: WantedMissing.Options?, _ completionHandler: @escaping (Result<WantedMissing>) -> Void) {
        print("but we are here")
        SonarrClient.makeAPICall(to: WantedMissingEndpoint.wantedMissing(options: options)) { (result) in
            print("we got here")
            self.handle(result: result, expectedResultType: WantedMissing.self) { result in
                switch result {
                case .success(let wantedMissing):
                    completionHandler(Result.success(wantedMissing as! WantedMissing))
                case .failure(let error):
                    completionHandler(Result.failure(error))
                }
            }
        }
    }
}
