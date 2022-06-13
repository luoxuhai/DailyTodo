//
//  AppSceneDIContainer.swift
//  DailyTodo
//
//  Created by Xuhai Luo on 2022/6/20.
//
    

import Foundation

final class AppDIContainer {
    // MARK: - DIContainers of scenes
    func makeGroupsSceneDIContainer() -> GroupsSceneDIContainer {
        return GroupsSceneDIContainer()
    }
}
