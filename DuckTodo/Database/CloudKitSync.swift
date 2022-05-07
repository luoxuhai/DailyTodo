import Foundation
import SyncKit
import RealmSwift

struct CloudKitSync {
    var synchronizer: CloudKitSynchronizer?
    static let shared = CloudKitSync()

    init() {
        let configuration = DatabaseManager.shared.db?.configuration
        if (configuration != nil) {
            synchronizer = CloudKitSynchronizer.privateSynchronizer(containerName: iCloudContainerId, configuration: configuration!)
        }
    }
    
    func sync(completion: @escaping (Error?) -> ()) {
        synchronizer?.synchronize(completion: completion)
    }
}
