//
//  Episode.swift
//  SwiftSonarr
//
//  Created by Eric Castillo on 11/18/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import Foundation

public struct Episode: Codable {
    public var seriesId: Int?
    public var episodeFileId: Int?
    public var seasonNumber: Int?
    public var episodeNumber: Int?
    public var title: String?
    public var airDate: Date?
    public var airDateUtc: Date?
    public var overview: String?
    public var hasFile: Bool?
    public var monitored: Bool?
    //public var sceneEpisodeNumber: Int?
    //public var sceneSeasonNumber: Int?
    //public var tvDbEpisodeId: Int?
    public var absoluteEpisodeNumber: Int?
    public var unverifiedSceneNumbering: Bool?
    public var id: Int?
    //public var series: Series?
}

/// Models the Episode endpoint from the Sonarr API.
enum EpisodeEndpoint: SonarrEndpoint {
    
    case episodes(ids: [Int])
    case episode(id: Int)
    case episodesInSeries(seriesId: Int)
    
    // MARK: - SonarrEndpoint conforming methods
    
    func provideValues() -> (path: String, httpMethod: HTTPMethod, parameters:[String:Any]?) {
        switch self {
        case .episodes(let ids):
            let uniqueIds = Array(Set(ids))
            let stringArray = uniqueIds.map { String($0) }
            let joined = stringArray.joined(separator: ",")
            return (path: "/episode?episodeIds=\(joined)", httpMethod: .get, parameters: nil)
        case .episode(let id):
            return (path: "/episode/\(id)", httpMethod: .get, parameters: nil)
        case .episodesInSeries(let seriesId):
            return (path: "/episode?seriesId=\(seriesId)", httpMethod: .get, parameters: nil)
        }
    }
    
    private func parameters(for id: Int) -> [String : String] {
        return [
            "id" : String(id)
        ]
    }
    
    private func parameters(for label: String) -> [String : String] {
        return [
            "label" : label
        ]
    }
    
    private func parameters(for tag: Tag) -> [String : Any] {
        guard let params = try! JSONSerialization.jsonObject(with: JSONEncoder().encode(tag)) as? [String: Any] else {
            return [:]
        }
        return params
    }
}

public extension Sonarr {
    
    public static func episodes(ids: [Int], _ completionHandler: @escaping (Result<[Episode]>) -> Void) {
        SonarrClient.makeAPICall(to: EpisodeEndpoint.episodes(ids: ids)) { (result) in
            self.handle(result: result, expectedResultType: [Episode].self) { result in
                switch result {
                case .success(let episodes):
                    completionHandler(Result.success(episodes as! [Episode]))
                case .failure(let error):
                    completionHandler(Result.failure(error))
                }
            }
        }
    }
    
    public static func episode(id: Int, _ completionHandler: @escaping (Result<Episode>) -> Void) {
        SonarrClient.makeAPICall(to: EpisodeEndpoint.episode(id: id)) { (result) in
            self.handle(result: result, expectedResultType: Episode.self) { result in
                switch result {
                case .success(let episode):
                    completionHandler(Result.success(episode as! Episode))
                case .failure(let error):
                    completionHandler(Result.failure(error))
                }
            }
        }
    }
    
    public static func episodesInSeries(seriesId: Int, label: String, _ completionHandler: @escaping (Result<[Episode]>) -> Void) {
        SonarrClient.makeAPICall(to: EpisodeEndpoint.episodesInSeries(seriesId: seriesId)) { (result) in
            self.handle(result: result, expectedResultType: [Episode].self) { result in
                switch result {
                case .success(let episodes):
                    completionHandler(Result.success(episodes as! [Episode]))
                case .failure(let error):
                    completionHandler(Result.failure(error))
                }
            }
        }
    }
}
