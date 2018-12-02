import SwiftSonarr

Sonarr.tag(id: 7) { (result) in
    print("GET TAG")
    switch result {
    case .success(let tag):
        print("tag found: "+tag.label)
    case .failure(let error):
        print("Error: \(error)")
        print("Error localized description: \(error.localizedDescription)")
        print("Error code: \(error.code)")
        print("Error code error description: \(error.code.errorDescription)")
        print("Error request url: \(error.requestUrl)")
        print("Error message: \(error.message)")
    }
}

Sonarr.createTag(label: "hi there") { (result) in
    print("CREATE TAG")
    switch result {
    case .success:
        print("tag created")
    case .failure(let error):
        print("Error: \(error)")
        print("Error localized description: \(error.localizedDescription)")
        print("Error code: \(error.code)")
        print("Error code error description: \(error.code.errorDescription)")
        print("Error request url: \(error.requestUrl)")
        print("Error message: \(error.message)")
    }
}


Sonarr.series { (result) in
    print("GET ALL SERIES")
    switch result {
    case .success(var series):
        print(series[0].title)
    case .failure(let error):
        print("Error: \(error)")
        print("Error localized description: \(error.localizedDescription)")
        print("Error code: \(error.code)")
        print("Error code error description: \(error.code.errorDescription)")
        print("Error request url: \(error.requestUrl)")
        print("Error message: \(error.message)")
    }
}



//Sonarr.queue { (result) in
//    print("GET QUEUE")
//    switch result {
//    case .success(var queue):
//        print(queue[0].series?.title)
//    case .failure(let error as NSError):
//        print("Error: \(error)")
//        print("Error code: \(error.code)")
//        print("Error user info: \(error.userInfo)")
//    }
//}

//Sonarr.series { (result) in
//    print("GET ALL SERIES")
//    switch result {
//    case .success(var series):
//        print(series[0].title)
//    case .failure(let error as NSError):
//        print(error)
//        print(error.code)
//        print(error.userInfo)
//    }
//}

//var options = WantedMissing.Options()
//options.page = 1
//Sonarr.wantedMissing(options: options) { (result) in
//    print("WANTED MISSING")
//    switch result {
//    case .success(let wantedMissing):
//        print("first in wanted missing: \(wantedMissing.records?[0].title)")
//    case .failure(let error as NSError):
//        print(error.userInfo)
//    }
//}

//Sonarr.systemStatus { (result) in
//    print("GET SYSTEM STATUS")
//    switch result {
//    case .success(let systemStatus):
//        print("Version: "+(systemStatus.version ?? "no version found"))
//    case .failure(let error as NSError):
//        print(error.code)
//        print(error.userInfo)
//    }
//}
//
//Sonarr.createTag(label: "hi there") { (result) in
//    print("CREATE TAG")
//    switch result {
//    case .success(let tag):
//        print("tag created: "+tag.label)
//    case .failure(let error as NSError):
//        print(error.userInfo)
//    }
//}
//
//Sonarr.tags { (result) in
//    print("GET TAGS")
//    switch result {
//    case .success(var tags):
//        tags[0].label = "updated to \(Int.random(in: 1...1000000))"
//        Sonarr.updateTag(tag: tags[0]) { (result) in
//            print("UPDATE TAG")
//            switch result {
//            case .success(let tag):
//                print("tag updated: "+tag.label)
//            case .failure(let error as NSError):
//                print(error.userInfo)
//            }
//        }
//    case .failure(let error as NSError):
//        print(error.code)
//        print(error.userInfo)
//    }
//}
//
//Sonarr.deleteTag(tagId: 1) { (result) in
//    print("DELETE TAG")
//    switch result {
//    case .success:
//        print("tag deleted")
//    case .failure(let error as NSError):
//        print(error.userInfo)
//    }
//}
