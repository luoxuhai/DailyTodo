//
//  BaseModel.swift
//  DailyTodo
//
//  Created by Xuhai Luo on 2022/6/25.
//
    

import RealmSwift

class BaseModel: Object {
    @Persisted(primaryKey: true) var id: String = ""
    // 是否已删除
    @Persisted var is_deleted: Bool = false
    // 创建日期
    @Persisted var created_at: Date
    // 更新日期
    @Persisted var updated_at: Date
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
