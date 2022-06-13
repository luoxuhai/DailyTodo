//
//  RealmTasksStorage.swift
//  DailyTodo
//
//  Created by Xuhai Luo on 2022/6/26.
//
    

import Foundation


final class RealmTasksStorage {
    
    private let realmStorage: RealmStorage
    
    init(realmStorage: RealmStorage = RealmStorage.shared) {
        self.realmStorage = realmStorage
    }
    
    // MARK: - Private
    
    
}

extension RealmTasksStorage: TasksStorage {
    func fetchTasks(query: TaskQuery, completion: @escaping (Result<TaskPage, Error>) -> Void) {
        realmStorage.performTask { realm in
            let tasks = realm?.objects(TaskModel.self).sorted(by: \.order, ascending: false).toArray(ofType: Task.self) ?? []
            
            completion(.success(TaskPage(total: tasks.count, items: tasks)))
        }
    }
}
