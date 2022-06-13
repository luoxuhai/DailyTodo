//
//  TaskRepository.swift
//  DailyTodo
//
//  Created by Xuhai Luo on 2022/6/19.
//
    

import Foundation


protocol TasksRepository {
    @discardableResult
    func fetchTasks(query: TaskQuery, completion: @escaping (Result<TaskPage, Error>) -> Void) -> Void?
}
