//
//  Series.swift
//  SwiftSonarr
//
//  Created by Eric Castillo on 11/18/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import Foundation

public struct Series: Codable {
    public var title: String?
    public var alternateTitles: [AlternativeTitle]?
    public var sortTitle: String?
    public let status: String?
    public let ended: Bool?
    public let overview: String?
    public let nextAiring: Date?
    public let previousAiring: Date?
    public let network: String?
    // TODO: Custom decode/encode for TimeInterval
    //public let airTime: TimeInterval?
    public let images: [SeriesImage]?
    public let seasons: [Season]?
    public let year: Int?
    public let path: String?
    public let qualityProfileId: Int?
    public let languageProfileId: Int?
    public let seasonFolder: Bool?
    public let monitored: Bool?
    public let useSceneNumbering: Bool?
    public let runtime: Int?
    public let tvdbId: Int?
    public let tvRageId: Int?
    public let tvMazeId: Int?
    public let firstAired: Date?
    public let lastInfoSync: Date?
    public let seriesType: SeriesType?
    public let cleanTitle: String?
    public let imdbId: String?
    public let titleSlug: String?
    public let rootFolderPath: String?
    public let certification: String?
    public let genres: [String]?
    public let tags: [Int]?
    public let added: Date?
    public let ratings: Rating?
    public let statistics: SeriesStatistics?
    public let id: Int?
}

public struct AlternativeTitle: Codable {
    public var title: String?
    public var seasonNumber: Int?
}

public struct SeriesImage: Codable {
    public var coverType: CoverType?
    public var url: String?
}

public enum CoverType: String, Codable {
    case fanart = "fanart"
    case banner = "banner"
    case poster = "poster"
}

public struct SeriesStatistics: Codable {
    public var seasonCount: Int?
    public let episodeFileCount: Int?
    public let episodeCount: Int?
    public var totalEpisodeCount: Int?
    public let sizeOnDisk: Int?
    public var percentOfEpisodes: Float?
}

public struct Season: Codable {
    public var seasonNumber: Int?
    public var monitored: Bool?
    public var statistics: SeasonStatistics?
}

public struct SeasonStatistics: Codable {
    public let nextAiring: Date?
    public let episodeFileCount: Int?
    public let episodeCount: Int?
    public var totalEpisodeCount: Int?
    public let sizeOnDisk: Int?
    public var percentOfEpisodes: Float?
}

public enum SeriesType: String, Codable {
    case standard = "standard"
    case daily = "daily"
    case anime = "anime"
}

public struct Rating: Codable {
    public var votes: Int?
    public var value: Double?
}


/// Models the Series endpoint from the Sonarr API.
enum SeriesEndpoint: SonarrEndpoint {
    
    case series()
    
    // MARK: - SonarrEndpoint conforming methods
    
    func provideValues() -> (path: String, httpMethod: HTTPMethod, parameters:[String:Any]?) {
        switch self {
        case .series():
            return (path: "/series", httpMethod: .get, parameters: nil)
        }
    }
}

public extension Sonarr {
    
    public static func series(_ completionHandler: @escaping (Result<[Series]>) -> Void) {
        print("but we are here")
        SonarrClient.makeAPICall(to: SeriesEndpoint.series()) { (result) in
            print("we got here")
            self.handle(result: result, expectedResultType: [Series].self) { result in
                switch result {
                case .success(let series):
                    completionHandler(Result.success(series as! [Series]))
                case .failure(let error):
                    completionHandler(Result.failure(error))
                }
            }
        }
    }
}
