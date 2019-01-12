//
//  Queue.swift
//  SwiftSonarr
//
//  Created by Eric Castillo on 11/23/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import Foundation

public struct Queue: Codable {
    public var page: Int
    public var pageSize: Int
    public var sortKey: String
    public var sortDirection: String
    public var totalRecords: Int
    public var records: [Queue.Record]
    
    public struct Record: Codable {
        public var seriesId: Int?
        public var episodeId: Int?
        //public var quality: [Quality]?
        public var size: Float?
        public var title: String?
        public var sizeleft: Float?
        var _timeleft: String?
        public var timeleft: TimeInterval?
        public var estimatedCompletionTime: Date?
        public var status: String?
        public var trackedDownloadStatus: String?
        //public var statusMessages: [String]?
        public var downloadId: String?
        public var itemProtocol: String?
        public var downloadClient: String?
        public var indexer: String?
        public var id: Int?
        
        enum CodingKeys: String, CodingKey {
            case itemProtocol = "protocol"
            case _timeleft = "timeleft"
            
            case seriesId, episodeId, size, title, sizeleft, estimatedCompletionTime, status, trackedDownloadStatus, downloadId, downloadClient, indexer, id
        }
        
        public init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            seriesId = try values.decode(Int.self, forKey: .seriesId)
            episodeId = try values.decode(Int.self, forKey: .episodeId)
            size = try values.decode(Float.self, forKey: .size)
            title = try values.decode(String.self, forKey: .title)
            sizeleft = try values.decode(Float.self, forKey: .sizeleft)
            _timeleft = try values.decode(String.self, forKey: ._timeleft)
            estimatedCompletionTime = try values.decode(Date.self, forKey: .estimatedCompletionTime)
            status = try values.decode(String.self, forKey: .status)
            trackedDownloadStatus = try values.decode(String.self, forKey: .trackedDownloadStatus)
            downloadId = try values.decode(String.self, forKey: .downloadId)
            itemProtocol = try values.decode(String.self, forKey: .itemProtocol)
            id = try values.decode(Int.self, forKey: .id)
            
            if let _timeleft = _timeleft {
                timeleft = parseDuration(_timeleft)
            }
        }
    }
}


func parseDuration(_ timeString:String) -> TimeInterval {
    guard !timeString.isEmpty else {
        return 0
    }
    
    var interval: Double = 0
    
    let parts = timeString.components(separatedBy: ":")
    for (index, part) in parts.reversed().enumerated() {
        interval += (Double(part) ?? 0) * pow(Double(60), Double(index))
    }
    
    return interval
}

/// Models the Queue endpoint from the Sonarr API.
enum QueueEndpoint: SonarrEndpoint {
    
    case queue()
    case queueDetails(episodeIds: [Int])
    case deleteFromQueue(itemId: Int, blacklist: Bool?)
    
    // MARK: - SonarrEndpoint conforming methods
    
    func provideValues() -> (path: String, httpMethod: HTTPMethod, parameters:[String:Any]?) {
        switch self {
        case .queue():
            return (path: "/queue", httpMethod: .get, parameters: nil)
        case .queueDetails(let episodeIds):
            let uniqueIds = Array(Set(episodeIds))
            let stringArray = uniqueIds.map { String($0) }
            let joined = stringArray.joined(separator: ",")
            return (path: "/queue/details?episodeIds=\(joined)", httpMethod: .get, parameters: nil)
        case .deleteFromQueue(let itemId, let blacklist):
            let params = parameters(for: itemId, blacklist: blacklist)
            return (path: "/queue/\(itemId)", httpMethod: .delete, parameters: params)
        }
    }
    
    private func parameters(for itemId: Int, blacklist: Bool?) -> [String : String] {
        return [
            "id" : String(itemId)
        ]
    }
}

public extension Sonarr {
    
    public static func queue(_ completionHandler: @escaping (Result<Queue>) -> Void) {
        SonarrClient.makeAPICall(to: QueueEndpoint.queue()) { (result) in
            self.handle(result: result, expectedResultType: Queue.self) { result in
                switch result {
                case .success(let queue):
                    completionHandler(Result.success(queue as! Queue))
                case .failure(let error):
                    completionHandler(Result.failure(error))
                }
            }
        }
    }
    
    public static func queueDetails(episodeIds: [Int], _ completionHandler: @escaping (Result<[Queue.Record]>) -> Void) {
        SonarrClient.makeAPICall(to: QueueEndpoint.queueDetails(episodeIds: episodeIds)) { (result) in
            self.handle(result: result, expectedResultType: [Queue.Record].self) { result in
                switch result {
                case .success(let queue):
                    completionHandler(Result.success(queue as! [Queue.Record]))
                case .failure(let error):
                    completionHandler(Result.failure(error))
                }
            }
        }
    }
    
    public static func deleteFromQueue(itemId: Int, blacklist: Bool?, _ completionHandler: @escaping (Result<Void>) -> Void) {
        SonarrClient.makeAPICall(to: QueueEndpoint.deleteFromQueue(itemId: itemId, blacklist: blacklist)) { (result) in
            self.handle(result: result) { result in
                switch result {
                case .success:
                    completionHandler(Result.success( Void() ))
                case .failure(let error):
                    completionHandler(Result.failure(error))
                }
            }
        }
    }
}


