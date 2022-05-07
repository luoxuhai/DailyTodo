import Foundation
import SyncKit
import RealmSwift
import Defaults

struct CloudKitSync {
    static var shared = CloudKitSync()
    var synchronizer: CloudKitSynchronizer?
    
    mutating func createWithConfig(_ configuration: Realm.Configuration) {
        self.synchronizer = CloudKitSynchronizer.privateSynchronizer(
            containerName: DTConfig.iCloudContainerId,
            configuration: configuration
        )
    }
    
    func sync(completion: ((Error?) -> ())? = nil) {
        if !Defaults[.cloudSyncEnabled] {
            return
        }
        
        synchronizer?.synchronize(completion: completion)
    }
    
    func subscribe(completion: ((Error?) -> ())?) {
        synchronizer?.subscribeForChangesInDatabase(completion: { error in
            completion?(error)
        })
    }
}

extension CloudKitSync {
    
}
