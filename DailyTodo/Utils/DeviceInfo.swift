import Foundation
import UIKit

private let infoDictionary : [String : Any] = Bundle.main.infoDictionary!

// App 信息
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

// 系统信息
struct SystemInfo {
    static let version = UIDevice.current.systemVersion
    static let udid = UIDevice.current.identifierForVendor
    static let deviceName = UIDevice.current.systemName
    static let deviceType = getDeviceType()
}


internal enum DeviceType {
    case iphone
    case ipad
    case mac
}

internal func getDeviceType() -> DeviceType {
#if targetEnvironment(macCatalyst)
    return .mac
#else
    if UIDevice.current.userInterfaceIdiom == .pad {
        return .ipad
    } else {
        return .iphone
    }
#endif
}
