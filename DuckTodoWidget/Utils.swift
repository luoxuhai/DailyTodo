import Foundation

struct AppGroup {
    static var groupId = "group.net.darkce.checklist"
    
    static var containerURL: URL {
        return FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: groupId)!
    }
}
