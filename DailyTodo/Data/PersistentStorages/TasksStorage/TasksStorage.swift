//
//  TasksStorage.swift
//  DailyTodo
//
//  Created by Xuhai Luo on 2022/6/26.
//
    

import Foundation


protocol TasksStorage {
    func fetchTasks(query: TaskQuery, completion: @escaping (Result<TaskPage, Error>) -> Void)
}
