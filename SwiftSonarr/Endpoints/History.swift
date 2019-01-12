//
//  History.swift
//  SwiftSonarr
//
//  Created by Eric Castillo on 1/5/19.
//  Copyright © 2019 Eric Castillo. All rights reserved.
//

import Foundation

public struct History: Codable {
    public var page: Int
    public var pageSize: Int
    public var sortKey: String
    public var sortDirection: String
    public var totalRecords: Int
    public var records: [History.Record]
    
    public struct Record: Codable {
        public var episodeId: Int?
        public var seriesId: Int?
        public var sourceTitle: String?
        public var language: Language?
        public var quality: Quality?
        public var qualityCutoffNotMet: Bool?
        public var languageCutoffNotMet: Bool?
        public var date: Date?
        public var downloadId: String?
        public var eventType: String?
        //public var data: ?????
        public var id: Int?
    }
    
    public struct Language: Codable {
        public var id: Int?
        public var name: String?
    }
    
    public struct Quality: Codable {
        public var quality: Quality2
        public var revision: Revision
        
        public struct Quality2: Codable {
            public var id: Int?
            public var name: String?
            public var source: String?
            public var resolution: Int?
        }
        
        public struct Revision: Codable {
            public var version: Int?
            public var real: Int?
        }
    }
}

/// Models the History endpoint from the Sonarr API.
enum HistoryEndpoint: SonarrEndpoint {
    
    case history(sortKey: String?)
    
    // MARK: - SonarrEndpoint conforming methods
    
    func provideValues() -> (path: String, httpMethod: HTTPMethod, parameters:[String:Any]?) {
        switch self {
        case .history(let sortKey):
            return (path: "/history", httpMethod: .get, parameters: nil)
        }
    }
}

public extension Sonarr {
    
    public static func history(sortKey: String?, _ completionHandler: @escaping (Result<History>) -> Void) {
        SonarrClient.makeAPICall(to: HistoryEndpoint.history(sortKey: sortKey)) { (result) in
            self.handle(result: result, expectedResultType: History.self) { result in
                switch result {
                case .success(let history):
                    completionHandler(Result.success(history as! History))
                case .failure(let error):
                    completionHandler(Result.failure(error))
                }
            }
        }
    }
}


