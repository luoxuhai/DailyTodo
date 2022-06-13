//
//  GroupsStorage.swift
//  DailyTodo
//
//  Created by Xuhai Luo on 2022/6/25.
//
    

import Foundation


protocol GroupsStorage {
    func fetchGroups(completion: @escaping (Result<TaskGroupPage, Error>) -> Void)
}
