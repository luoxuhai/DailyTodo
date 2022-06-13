//
//  RealmGroupsStorage.swift
//  DailyTodo
//
//  Created by Xuhai Luo on 2022/6/25.
//


import Foundation


final class RealmGroupsStorage {
    
    private let realmStorage: RealmStorage
    
    init(realmStorage: RealmStorage = RealmStorage.shared) {
        self.realmStorage = realmStorage
    }
    
    // MARK: - Private
    
    
}

extension RealmGroupsStorage: GroupsStorage {
    func fetchGroups(completion: @escaping (Result<TaskGroupPage, Error>) -> Void) {
        realmStorage.performTask { realm in
            let groups = realm?.objects(GroupModel.self).sorted(by: \.order, ascending: false).toArray(ofType: TaskGroup.self) ?? []
            
            completion(.success(TaskGroupPage(total: groups.count, items: groups)))
        }
    }
}
