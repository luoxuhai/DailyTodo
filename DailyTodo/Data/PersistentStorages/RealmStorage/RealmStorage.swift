//
//  RealmStorage.swift
//  DailyTodo
//
//  Created by Xuhai Luo on 2022/6/25.
//


import Foundation
import RealmSwift


final class RealmStorage {
    static let shared = RealmStorage()
    var realm: Realm?
    
    private init() {
        let configuration = Realm.Configuration(
            fileURL: self.getDataFileURL(),
            schemaVersion: 8,
            objectTypes: [GroupModel.self, TaskModel.self]
        )
        
        self.realm = try! Realm(configuration: configuration)
        
        self.sync(configuration: configuration)
    }
    
    private func getDataFileURL() -> URL {
        var dir = ETDirectory.documentDirectory!.appendingPathComponent("db")
        let fileURL = dir.appendingPathComponent("default.realm")
        let exist = FileManager.default.fileExists(atPath: dir.path)
        var resourceValues = URLResourceValues()
        resourceValues.isExcludedFromBackup = true
        
        if !exist {
            try! FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true, attributes: nil)
        }
        try! dir.setResourceValues(resourceValues)
        
        print("Realm data file path: \(fileURL)")
        return fileURL
    }
    
    private func sync(configuration: Realm.Configuration) {
        CloudKitSync.shared.createWithConfig(configuration)
        CloudKitSync.shared.sync()
    }
    
    func performTask(_ block: @escaping (Realm? ) -> Void, onFailure: ((Error? ) -> Void)? = nil) {
        do {
            try realm?.write {
                block(self.realm)
            }
        } catch {
            onFailure?(error)
        }
    }
}
