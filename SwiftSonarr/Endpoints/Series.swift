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
    public var seasonCount: Int?
    public var totalEpisodeCount: Int?
    public let episodeCount: Int?
    public let episodeFileCount: Int?
    public let sizeOnDisk: Int?
    public let status: String?
    public let overview: String?
    public let previousAiring: Date?
    public let network: String?
    public let airTime: TimeInterval?
    public let images: [Image]?
    public let seasons: [Season]?
    public let year: Int?
    public let path: String?
    public let profileId: Int?
    public let seasonFolder: Bool?
    public let monitored: Bool?
    public let useSceneNumbering: Bool?
    public let runtime: Int?
    public let tvdbId: Int?
    public let tvRageId: Int?
    public let tvMazeId: Int?
    public let firstAired: Date?
    public let lastInfoSync: Date?      // "2018-11-19T15:18:23.3144168Z"
    public let seriesType: SeriesType?
    public let cleanTitle: String?
    public let imdbId: Int?
    public let titleSlug: String?
    public let certification: String?
    public let genres: [String]?
    public let tags: [Int]?
    public let added: Date?
    public let ratings: Rating?
    public let qualityProfileId: Int?
    public let id: Int?
    
    public struct AlternativeTitle: Codable {
        public var title: String?
        public var seasonNumber: Int?
    }
    
    public struct Image: Codable {
        public var coverType: String?
        public var url: String?
    }
    
    public struct Season: Codable {
        public var seasonNumber: Int?
        public var monitored: Bool?
        public var statistics: Statistic?
    }
    
    public struct Statistic: Codable {
        public var previousAiring: Date?
        public var episodeFileCount: Int?
        public var episodeCount: Int?
        public var totalEpisodeCount: Int?
        public var sizeOnDisk: Int?
        public var percentOfEpisodes: Int?
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
}
