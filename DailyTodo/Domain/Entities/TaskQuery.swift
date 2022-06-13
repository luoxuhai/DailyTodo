//
//  TaskQuery.swift
//  DailyTodo
//
//  Created by Xuhai Luo on 2022/6/26.
//
    

import Foundation


struct TaskQuery: Equatable {
    let parent_id: String?
    let name: String?
    let note: String?
}
