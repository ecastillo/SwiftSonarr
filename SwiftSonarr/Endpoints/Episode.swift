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
    public var sceneEpisodeNumber: Int?
    public var sceneSeasonNumber: Int?
    public var tvDbEpisodeId: Int?
    public var absoluteEpisodeNumber: Int?
    public var id: Int?
    public var series: Series?
}
