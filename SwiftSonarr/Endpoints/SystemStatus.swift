//
//  SystemStatus.swift
//  SwiftSonarr
//
//  Created by Eric Castillo on 11/11/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import Foundation

public struct SystemStatus: Decodable {
    public var version: String?
    public var buildTime: String?
    public var isDebug: Bool?
    public var isProduction: Bool?
    public var isAdmin: Bool?
    public let isUserInteractive: Bool?
    public let startupPath: String?
    public let appData: String?
    public let osName: String?
    public let osVersion: String?
    public let isMonoRuntime: Bool?
    public let isMono: Bool?
    public let isLinux: Bool?
    public let isOsx: Bool?
    public let isWindows: Bool?
    public let branch: String?
    public let authentication: String?
    public let sqliteVersion: String?
    public let urlBase: String?
    public let runtimeVersion: String?
    public let runtimeName: String?
    
    
}

/// Models the SystemStatus endpoint from the Sonarr API.
enum SystemStatusEndpoint: SonarrEndpoint {
    
    case systemStatus()
    
    // MARK: - SonarrEndpoint conforming methods
    
    func provideValues() -> (path: String, httpMethod: HTTPMethod, parameters:[String:Any]?) {
        switch self {
        case .systemStatus():
            return (path: "/system/status", httpMethod: .get, parameters: nil)
        }
    }
}

public extension Sonarr {
    
    public static func systemStatus(_ completionHandler: @escaping (Result<SystemStatus>) -> Void) {
        SonarrClient.makeAPICall(to: SystemStatusEndpoint.systemStatus()) { (result) in
            self.handle(result: result, expectedResultType: SystemStatus.self) { result in
                switch result {
                case .success(let systemStatus):
                    completionHandler(Result.success(systemStatus as! SystemStatus))
                case .failure(let error):
                    completionHandler(Result.failure(error))
                }
            }
        }
    }
}
