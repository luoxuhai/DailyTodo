//
//  UseCase.swift
//  DailyTodo
//
//  Created by Xuhai Luo on 2022/6/23.
//
    

import Foundation

public protocol UseCase {
    @discardableResult
    func start() -> Void?
}
