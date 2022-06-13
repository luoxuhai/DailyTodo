//
//  GroupSceneDIContainer.swift
//  DailyTodo
//
//  Created by Xuhai Luo on 2022/6/20.
//
    

import Foundation

final class GroupsSceneDIContainer {
    
    // MARK: - Persistent Storage
    
    lazy var groupsStorage: GroupsStorage = RealmGroupsStorage()

    // MARK: - Use Cases

    func makeFetchGroupsUseCase(completion: @escaping (FetchGroupsUseCase.ResultValue) -> Void) -> UseCase {
        return FetchGroupsUseCase(completion: completion, groupsRepository: makeGroupsRepository())
    }
    
    // MARK: - Repositories

    func makeGroupsRepository() -> GroupsRepository {
        return DefaultGroupsRepository(groupsStorage: groupsStorage)
    }
}
