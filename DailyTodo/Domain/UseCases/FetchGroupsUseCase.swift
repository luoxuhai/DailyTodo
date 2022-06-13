//
//  FetchGroupsUseCase.swift
//  DailyTodo
//
//  Created by Xuhai Luo on 2022/6/23.
//


import Foundation


final class FetchGroupsUseCase: UseCase {
    
    typealias ResultValue = (Result<TaskGroupPage, Error>)
    
    private let completion: (ResultValue) -> Void
    private let groupsRepository: GroupsRepository
    
    init(completion: @escaping (ResultValue) -> Void,
         groupsRepository: GroupsRepository) {

        self.completion = completion
        self.groupsRepository = groupsRepository
    }

    func start() -> Void? {
        groupsRepository.fetchGroups(completion: completion)
        return nil
    }
}
