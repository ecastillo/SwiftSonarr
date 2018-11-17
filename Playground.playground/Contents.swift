import SwiftSonarr


Sonarr.systemStatus { (result) in
    switch result {
    case .success(let systemStatus):
        print("Version: "+(systemStatus.version ?? "no version found"))
    case .failure(let error as NSError):
        print(error.code)
        print(error.userInfo)
    }
}

Sonarr.createTag(label: "hi there") { (result) in
    switch result {
    case .success(let tag):
        print("tag created: "+(tag.label ?? "no tag label found"))
    case .failure(let error as NSError):
        print(error.userInfo)
    }
}

Sonarr.tags { (result) in
    switch result {
    case .success(let tags):
        print("tag[0]: "+(tags[0].label ?? "no labels found"))
    case .failure(let error as NSError):
        print(error.code)
        print(error.userInfo)
    }
}
