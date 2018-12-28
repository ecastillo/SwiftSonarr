//
//  Diskspace.swift
//  SwiftSonarr
//
//  Created by Eric Castillo on 11/11/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import Foundation

public struct Disk: Decodable {
    public var path: String?
    public var label: String?
    public var freeSpace: Int?
    public var totalSpace: Int?
}

/// Models the System Status endpoint from the Sonarr API.
enum DiskspaceEndpoint: SonarrEndpoint {
    
    case diskspace()
    
    // MARK: - SonarrEndpoint conforming methods
    
    func provideValues() -> (path: String, httpMethod: HTTPMethod, parameters:[String:Any]?) {
        switch self {
        case .diskspace():
            return (path: "/diskspace", httpMethod: .get, parameters: nil)
        }
    }
}

public extension Sonarr {
    
    public static func diskspace(_ completionHandler: @escaping (Result<[Disk]>) -> Void) {
        SonarrClient.makeAPICall(to: DiskspaceEndpoint.diskspace()) { (result) in
            self.handle(result: result, expectedResultType: [Disk].self) { result in
                switch result {
                case .success(let diskspace):
                    completionHandler(Result.success(diskspace as! [Disk]))
                case .failure(let error):
                    completionHandler(Result.failure(error))
                }
            }
        }
    }
}
