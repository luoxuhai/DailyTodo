import RealmSwift

class TaskModel: BaseModel {
    // 上级id
    @Persisted var parent_id: String = ""
    // 清单项名称
    @Persisted var name: String = ""
    // 备注
    @Persisted var notes: String?
    // 状态
    @Persisted var status = TaskModelStatus.inProgress
    // 顺序
    @Persisted var order: Double
    
    override static func indexedProperties() -> [String] {
        return ["id", "parent_id"]
    }
}

enum TaskModelStatus: String, PersistableEnum {
    // 进行中
    case inProgress
    // 已完成
    case complete
}
