import RealmSwift

class GroupModel: BaseModel {
    // 清单名称
    @Persisted var name: String = ""
    // 颜色
    @Persisted var color: String = ""
    // 图标
    @Persisted var icon: String = ""
    // 顺序
    @Persisted var order: Double
    
    override static func indexedProperties() -> [String] {
        return ["id"]
    }
}

enum GroupStatus: String, PersistableEnum {
    // 进行中
    case inProgress
    // 已完成
    case complete
}
