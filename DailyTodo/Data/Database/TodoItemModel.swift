import RealmSwift

class TodoItemModel: Object {
    @Persisted(primaryKey: true) var id: String = ""
    // 上级id
    @Persisted var parent_id: String = ""
    // 清单项名称
    @Persisted var name: String = ""
    // 备注
    @Persisted var notes: String?
    // 状态
    @Persisted var status = TodoItemStatus.inProgress
    // 顺序
    @Persisted var order: Double
    // 创建日期
    @Persisted var created_at: Date
    // 更新日期
    @Persisted var updated_at: Date
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    override static func indexedProperties() -> [String] {
        return ["id", "parent_id"]
    }
}

enum TodoItemStatus: String, PersistableEnum {
    // 进行中
    case inProgress
    // 已完成
    case complete
}
