import Foundation

private let infoDictionary : [String : Any] = Bundle.main.infoDictionary!

struct ApplicationInfo {
    // App 显示名称
    static let name = infoDictionary["CFBundleDisplayName"] as! String
    // App 版本号
    static let version = infoDictionary["CFBundleShortVersionString"] as! String
}

extension ApplicationInfo {
    // 构建版本
    static let bundleVersion = infoDictionary["CFBundleVersion"] as! String
}
