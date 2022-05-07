import RealmSwift

class ChecklistModel: Object {
    @Persisted(primaryKey: true) var id: UUID
    // 清单名称
    @Persisted var name: String = ""
    // 颜色
    @Persisted var color: String = ""
    // 图标
    @Persisted var icon: String = ""
    // 状态
    @Persisted var status = ChecklistStatus.inProgress
    // 创建日期
    @Persisted var created_at: Date
    // 更新日期
    @Persisted var updated_at: Date
}


enum ChecklistStatus: String, PersistableEnum {
    // 进行中
    case inProgress
    // 已完成
    case complete
}
