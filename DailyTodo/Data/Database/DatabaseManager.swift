import RealmSwift
import Foundation

public typealias RealmDoneTask = () -> Void

class DatabaseManager {

    static var shared = DatabaseManager()
    static var dbDir = ETDirectory.documentDirectory!.appendingPathComponent("db")
    let db: Realm?
    let fileURL = dbDir.appendingPathComponent("default.realm")
    let schemaVersion: UInt64 = 7
    var observeToken: NotificationToken?

    private init() {
        let exist = FileManager.default.fileExists(atPath: DatabaseManager.dbDir.path)
        var resourceValues = URLResourceValues()
        resourceValues.isExcludedFromBackup = true
        if !exist {
            try! FileManager.default.createDirectory(at: DatabaseManager.dbDir, withIntermediateDirectories: true, attributes: nil)
        }
        try! DatabaseManager.dbDir.setResourceValues(resourceValues)
        
        let configuration = Realm.Configuration(
            fileURL: fileURL,
            schemaVersion: self.schemaVersion,
            objectTypes: [TodoItemModel.self, ChecklistModel.self]
        )

        self.db = try! Realm(configuration: configuration)

        if ((self.db?.configuration) != nil) {
            CloudKitSync.shared.createWithConfig(configuration)
            CloudKitSync.shared.sync()
            self.registerChangeListener()
        }

        if (self.db == nil) {
            print("DB init error")
        }
    }
}

extension DatabaseManager {
    func registerChangeListener() {
        self.observeToken = self.db!.observe { notification, realm in
            if notification == .didChange {
                CloudKitSync.shared.sync()
            }
        }
    }
    
    func removeChangeListener() {
        self.observeToken?.invalidate()
    }
    
    func clear() {
        try? self.db?.write {
            self.db?.deleteAll()
        }
    }
}

extension DatabaseManager {
    // MARK: 添加单个对象
    /// 添加单个对象
    /// - Parameters:
    ///   - object: 对象
    ///   - update: 是否更新
    ///   - task: 添加后操作
    func add(_ object: Object, update: Realm.UpdatePolicy = .error, complete: @escaping RealmDoneTask) {
        guard let currentDB = db else {
            return
        }

        try? currentDB.write {
            currentDB.add(object, update: update)
            complete()
        }
    }
}

extension DatabaseManager {
    // MARK: 在事务中删除一个对象
    /// 在事务中删除一个对象
    /// - Parameters:
    ///   - object: 单个被删除的对象
    ///   - task: 删除后操作
    func delete(_ object: Object, complete: @escaping RealmDoneTask) {
        guard let currentDB = db else {
            return
        }
        
        do {
            try currentDB.write {
                currentDB.delete(object)
                complete()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension DatabaseManager {
    // MARK: 更改某个对象（根据主键存在来更新，元素必须有主键）
    /// 更改某个对象（根据主键存在来更新）
    /// - Parameters:
    ///   - object: 某个对象
    ///   - update: 是否更新
    func update(object: Object, update: Realm.UpdatePolicy = .modified, complete: @escaping RealmDoneTask) {
        guard let currentDB = db else {
            return
        }
        try? currentDB.write {
            currentDB.add(object, update: update)
            complete()
        }
    }
}

extension Results {
    func toArray<T>(ofType: T.Type) -> [T] {
        var array = [T]()
        for i in 0 ..< count {
            if let result = self[i] as? T {
                array.append(result)
            }
        }
        
        return array
    }
}
