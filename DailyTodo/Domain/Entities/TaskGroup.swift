//
//  Group.swift
//  DailyTodo
//
//  Created by Xuhai Luo on 2022/6/19.
//
    

import Foundation

struct TaskGroup: Equatable, Identifiable {
    typealias Identifier = String
    let id: Identifier
    let name: String
    let color: String
    let order: Double
}

struct TaskGroupPage: Equatable {
    let total: Int
    let items: [TaskGroup]
}
