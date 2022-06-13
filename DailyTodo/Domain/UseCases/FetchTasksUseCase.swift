//
//  FetchTasksUseCase.swift
//  DailyTodo
//
//  Created by Xuhai Luo on 2022/6/26.
//
    

import Foundation


final class FetchTasksUseCase: UseCase {
    
    typealias ResultValue = (Result<TaskPage, Error>)
    
    private let completion: (ResultValue) -> Void
    private let tasksRepository: TasksRepository
    private let query: TaskQuery
    
    init(query: TaskQuery,
         completion: @escaping (ResultValue) -> Void,
         tasksRepository: TasksRepository) {

        self.query = query
        self.completion = completion
        self.tasksRepository = tasksRepository
    }

    func start() -> Void? {
        tasksRepository.fetchTasks(query: query, completion: completion)
        return nil
    }
}
