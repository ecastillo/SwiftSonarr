//
//  JSON+DateFormats.swift
//  SwiftSonarr
//
//  Created by Eric Castillo on 11/19/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import Foundation


extension Formatter {
    static let sonarrDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    static let sonarrDateTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssX"
        return formatter
    }()
    static let sonarrDateTimeLong: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter
    }()
}

extension JSONDecoder.DateDecodingStrategy {
    static let sonarr = custom { decoder throws -> Date in
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        
        if let date = Formatter.sonarrDate.date(from: string) {
            return date
        } else if let date = Formatter.sonarrDateTime.date(from: string) {
            return date
        } else if let date = Formatter.sonarrDateTimeLong.date(from: string) {
            return date
        }
        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date: \(string)")
    }
}

extension JSONEncoder.DateEncodingStrategy {
    static let sonarr = custom { date, encoder throws in
        var container = encoder.singleValueContainer()
        try container.encode(Formatter.sonarrDate.string(from: date))
    }
}
