import Defaults
import Foundation

private let extensionDefaults = UserDefaults(suiteName: AppGroup.groupId)!

enum AppearanceKeys: String, Defaults.Serializable {
    case auto = "auto"
    case light = "light"
    case dark = "dark"
}

// 用户设置
extension Defaults.Keys {
    // 外观
    static let appearance = Key<AppearanceKeys>("appearance", default: .auto)
    // 触感反馈
    static let hapticFeedbackEnabled = Key<Bool>("hapticFeedbackEnabled", default: true)
    // 应用锁
    static let appLockEnabled = Key<Bool>("appLockEnabled", default: false, suite: extensionDefaults)
    // 隐藏小组件
    static let hideWidgetEnabled = Key<Bool>("hideWidgetEnabled", default: false, suite: extensionDefaults)
    // 搜索
    static let spotlightEnabled = Key<Bool>("spotlightEnabled", default: false)
    // 同步
    static let cloudSyncEnabled = Key<Bool>("cloudSyncEnabled", default: false)
}

// 内购
extension Defaults.Keys {
    // 是否购买
    static let isPurchased = Key<Bool>("isPurchased", default: false)
}

// 调试
extension Defaults.Keys {
    static let isDebug = Key<Bool>("isDebug", default: false)
}

let publisher = Defaults.publisher(.appLockEnabled)


// 关闭应用锁重置 隐藏小组件状态
let observer = Defaults.observe(.appLockEnabled) { change in
    if !change.newValue {
        Defaults.reset(.hideWidgetEnabled)
    }
}
