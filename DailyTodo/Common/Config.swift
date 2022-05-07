import Foundation

// App Group
struct DTAppGroup {
    static var appGroupId = "group.\(Bundle.main.bundleIdentifier!)"
    
    static var containerURL: URL {
        return FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: appGroupId)!
    }
}

// 目录
enum ETDirectory {
    static var documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    static var appGroupDirectory = AppGroup.containerURL
}

struct DTConfig {
    static let developerId = "1572453992"
    static let appId = "1622534799"
    static let email = "darkce97@gmail.com"
    static let iCloudContainerId = "iCloud.net.darkce.checklist"
    
    // 内购产品id
    static let productId = "net.darkce.checklist.purchase.pro"
    
    static let feedbackUrl = "https://support.qq.com/product/404395"
    static let privacyPolicy = ["zh_cn": "https://privatespace-4gagcjdu022008e0-1258504012.tcloudbaseapp.com/zh-cn/privacy-policy.html",
                                "en_us":"https://private-space-web.netlify.app/en-us/privacy-policy"]
    static let userAgreement = ["zh_cn": "https://privatespace-4gagcjdu022008e0-1258504012.tcloudbaseapp.com/zh-cn/privacy-policy.html",
                                "en_us":"https://private-space-web.netlify.app/en-us/privacy-policy"]
}

struct MoreAppUrls {
    static let PSpace = "https://apps.apple.com/app/id1597534147"
}

struct AppGroup {
    static var groupId = "group.net.darkce.checklist"
    
    static var containerURL: URL {
        return FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: groupId)!
    }
}
