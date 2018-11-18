import SwiftSonarr


Sonarr.systemStatus { (result) in
    print("GET SYSTEM STATUS")
    switch result {
    case .success(let systemStatus):
        print("Version: "+(systemStatus.version ?? "no version found"))
    case .failure(let error as NSError):
        print(error.code)
        print(error.userInfo)
    }
}

Sonarr.createTag(label: "hi there") { (result) in
    print("CREATE TAG")
    switch result {
    case .success(let tag):
        print("tag created: "+tag.label)
    case .failure(let error as NSError):
        print(error.userInfo)
    }
}

Sonarr.tags { (result) in
    print("GET TAGS")
    switch result {
    case .success(var tags):
        tags[0].label = "updated to \(Int.random(in: 1...1000000))"
        Sonarr.updateTag(tag: tags[0]) { (result) in
            print("UPDATE TAG")
            switch result {
            case .success(let tag):
                print("tag updated: "+tag.label)
            case .failure(let error as NSError):
                print(error.userInfo)
            }
        }
    case .failure(let error as NSError):
        print(error.code)
        print(error.userInfo)
    }
}

Sonarr.deleteTag(tagId: 1) { (result) in
    print("DELETE TAG")
    switch result {
    case .success:
        print("tag deleted")
    case .failure(let error as NSError):
        print(error.userInfo)
    }
}




