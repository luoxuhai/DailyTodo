//
//  Task.swift
//  DailyTodo
//
//  Created by Xuhai Luo on 2022/6/26.
//
    

import Foundation

struct Task: Equatable, Identifiable {
    typealias Identifier = String
    let id: String
    let parent_id: String
    let name: String
    let note: String
    let order: Double
}

struct TaskPage: Equatable {
    let total: Int
    let items: [Task]
}
