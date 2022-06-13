//
//  GroupRepository.swift
//  DailyTodo
//
//  Created by Xuhai Luo on 2022/6/19.
//
    
import Foundation

protocol GroupsRepository {
    @discardableResult
    func fetchGroups(completion: @escaping (Result<TaskGroupPage, Error>) -> Void) -> Void?
}
