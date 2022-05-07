import RealmSwift
import Foundation

public typealias RealmDoneTask = () -> Void

class DatabaseManager {

    let db: Realm?
    static let shared = DatabaseManager()
    static var dbDir = ETDirectory.documentDirectory!.appendingPathComponent("db")
    let fileURL = dbDir.appendingPathComponent("default.realm")

    private init() {
        
        let exist = FileManager.default.fileExists(atPath: DatabaseManager.dbDir.path)
        var resourceValues = URLResourceValues()
        resourceValues.isExcludedFromBackup = true
        if !exist {
            try! FileManager.default.createDirectory(at: DatabaseManager.dbDir, withIntermediateDirectories: true, attributes: nil)
        }
        try! DatabaseManager.dbDir.setResourceValues(resourceValues)
        
        let config = Realm.Configuration(fileURL: fileURL)
        Realm.Configuration.defaultConfiguration = config
        db = try! Realm()
        
        if (db == nil) {
            print("DB init error")
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
    func add(_ object: Object, update: Realm.UpdatePolicy = .error, task: @escaping RealmDoneTask) {
        guard let currentDB = db else {
            return
        }

        try? currentDB.write {
            currentDB.add(object, update: update)
            task()
        }
    }
}

extension DatabaseManager {
    // MARK: 在事务中删除一个对象
    /// 在事务中删除一个对象
    /// - Parameters:
    ///   - object: 单个被删除的对象
    ///   - task: 删除后操作
    func delete(_ object: Object, task: @escaping RealmDoneTask) {
        guard let currentDB = db else {
            return
        }
        try? currentDB.write {
            currentDB.delete(object)
            task()
        }
    }
}

extension DatabaseManager {
    // MARK: 更改某个对象（根据主键存在来更新，元素必须有主键）
    /// 更改某个对象（根据主键存在来更新）
    /// - Parameters:
    ///   - object: 某个对象
    ///   - update: 是否更新
    func update(object: Object, update: Realm.UpdatePolicy = .modified) {
        guard let currentDB = db else {
            return
        }
        try? currentDB.write {
            currentDB.add(object, update: update)
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
