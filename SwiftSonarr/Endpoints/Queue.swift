//
//  Queue.swift
//  SwiftSonarr
//
//  Created by Eric Castillo on 11/23/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import Foundation

public struct QueueItem: Codable {
    public var series: Series?
    public var episode: Episode?
    //public var quality: [Quality]?
    public var size: Int?
    public var title: String?
    public var sizeleft: Int?
    var _timeleft: String?
    public var timeleft: TimeInterval?
    public var estimatedCompletionTime: Date?
    public var status: String?
    public var trackedDownloadStatus: String?
    //public var statusMessages: [String]?
    public var downloadId: String?
    public var itemProtocol: String?
    public var id: Int?
    
    enum CodingKeys: String, CodingKey {
        case itemProtocol = "protocol"
        case _timeleft = "timeleft"
        
        case series, episode, size, title, sizeleft, estimatedCompletionTime, status, trackedDownloadStatus, downloadId, id
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        series = try values.decode(Series.self, forKey: .series)
        episode = try values.decode(Episode.self, forKey: .episode)
        size = try values.decode(Int.self, forKey: .size)
        title = try values.decode(String.self, forKey: .title)
        sizeleft = try values.decode(Int.self, forKey: .sizeleft)
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
    case deleteFromQueue(itemId: Int, blacklist: Bool?)
    
    // MARK: - SonarrEndpoint conforming methods
    
    func provideValues() -> (path: String, httpMethod: HTTPMethod, parameters:[String:Any]?) {
        switch self {
        case .queue():
            return (path: "/queue", httpMethod: .get, parameters: nil)
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
    
    public static func queue(_ completionHandler: @escaping (Result<[QueueItem]>) -> Void) {
        SonarrClient.makeAPICall(to: QueueEndpoint.queue()) { (result) in
            self.handle(result: result, expectedResultType: [QueueItem].self) { result in
                switch result {
                case .success(let queue):
                    completionHandler(Result.success(queue as! [QueueItem]))
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


