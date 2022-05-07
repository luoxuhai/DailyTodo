import Defaults
import Foundation

private let extensionDefaults = UserDefaults(suiteName: AppGroup.groupId)!

// 用户设置
extension Defaults.Keys {
    // 应用锁
    static let appLockEnabled = Key<Bool>("appLockEnabled", default: false, suite: extensionDefaults)
    // 隐藏小组件
    static let hideWidgetEnabled = Key<Bool>("hideWidgetEnabled", default: false, suite: extensionDefaults)
}
