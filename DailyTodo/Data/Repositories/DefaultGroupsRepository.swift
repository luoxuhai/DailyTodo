//
//  GroupsRepository.swift
//  DailyTodo
//
//  Created by Xuhai Luo on 2022/6/23.
//


import Foundation

final class DefaultGroupsRepository {
    
    private var groupsStorage: GroupsStorage
    
    init(groupsStorage: GroupsStorage) {
        self.groupsStorage = groupsStorage
    }
    
}

extension DefaultGroupsRepository: GroupsRepository {
    func fetchGroups(completion: @escaping (Result<TaskGroupPage, Error>) -> Void) -> Void? {
        return groupsStorage.fetchGroups(completion: completion)
    }
}
