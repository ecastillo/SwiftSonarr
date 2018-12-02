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
    //public var timeleft: TimeInterval?
    public var estimatedCompletionTime: Date?
    public var status: String?
    public var trackedDownloadStatus: String?
    //public var statusMessages: [String]?
    public var downloadId: String?
    public var itemProtocol: String?
    public var id: Int?
    
    enum CodingKeys: String, CodingKey {
        case itemProtocol = "protocol"
        
        case series, episode, size, title, sizeleft, estimatedCompletionTime, status, trackedDownloadStatus, downloadId, id
    }
}

/// Models the Queue endpoint from the Sonarr API.
enum QueueEndpoint: SonarrEndpoint {
    
    case queue()
    case deleteFromQueue(itemId: Int, blacklist: Bool?)
    
    // MARK: - SonarrEndpoint conforming methods
    
    func provideValues() -> (path: String, httpMethod: HTTPMethod, parameters:[String:Any]?) {
        switch self {
        case .queue():
            return (path: "/queuez", httpMethod: .get, parameters: nil)
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


