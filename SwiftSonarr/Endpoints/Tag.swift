//
//  Tag.swift
//  SwiftSonarr
//
//  Created by Eric Castillo on 11/11/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import Foundation

public struct Tag: Codable {
    public var label: String
    public var id: Int
}

/// Models the Tag endpoint from the Sonarr API.
enum TagEndpoint: SonarrEndpoint {
    
    case tags()
    case tag(id: Int)
    case createTag(label: String)
    case updateTag(tag: Tag)
    case deleteTag(tagId: Int)
    
    // MARK: - SonarrEndpoint conforming methods
    
    func provideValues() -> (path: String, httpMethod: HTTPMethod, parameters:[String:Any]?) {
        switch self {
        case .tags():
            return (path: "/tag", httpMethod: .get, parameters: nil)
        case .tag(let id):
            return (path: "/tag/\(id)", httpMethod: .get, parameters: nil)
        case .createTag(let label):
            let params = parameters(for: label)
            return (path: "/tag", httpMethod: .post, parameters: params)
        case .updateTag(let tag):
            let params = parameters(for: tag)
            return (path: "/tag", httpMethod: .put, parameters: params)
        case .deleteTag(let tagId):
            return (path: "/tag/\(tagId)", httpMethod: .delete, parameters: nil)
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
    
    public static func tags(_ completionHandler: @escaping (Result<[Tag]>) -> Void) {
        SonarrClient.makeAPICall(to: TagEndpoint.tags()) { (result) in
            self.handle(result: result, expectedResultType: [Tag].self) { result in
                switch result {
                case .success(let tags):
                    completionHandler(Result.success(tags as! [Tag]))
                case .failure(let error):
                    completionHandler(Result.failure(error))
                }
            }
        }
    }
    
    public static func tag(id: Int, _ completionHandler: @escaping (Result<Tag>) -> Void) {
        SonarrClient.makeAPICall(to: TagEndpoint.tag(id: id)) { (result) in
            self.handle(result: result, expectedResultType: Tag.self) { result in
                switch result {
                case .success(let tag):
                    completionHandler(Result.success(tag as! Tag))
                case .failure(let error):
                    completionHandler(Result.failure(error))
                }
            }
        }
    }
    
    public static func createTag(label: String, _ completionHandler: @escaping (Result<Tag>) -> Void) {
        SonarrClient.makeAPICall(to: TagEndpoint.createTag(label: label)) { (result) in
            self.handle(result: result, expectedResultType: Tag.self) { result in
                switch result {
                case .success(let tag):
                    completionHandler(Result.success(tag as! Tag))
                case .failure(let error):
                    completionHandler(Result.failure(error))
                }
            }
        }
    }
    
    public static func updateTag(tag: Tag, _ completionHandler: @escaping (Result<Tag>) -> Void) {
        SonarrClient.makeAPICall(to: TagEndpoint.updateTag(tag: tag)) { (result) in
            self.handle(result: result, expectedResultType: Tag.self) { result in
                switch result {
                case .success(let tag):
                    completionHandler(Result.success(tag as! Tag))
                case .failure(let error):
                    completionHandler(Result.failure(error))
                }
            }
        }
    }
    
    public static func deleteTag(tagId: Int, _ completionHandler: @escaping (Result<Void>) -> Void) {
        SonarrClient.makeAPICall(to: TagEndpoint.deleteTag(tagId: tagId)) { (result) in
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


