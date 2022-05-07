import UIKit
import CloudKit
import SwiftyStoreKit
import RealmSwift
import Defaults
import SDCAlertView

#if !DEBUG
import Firebase
import Sentry
#endif

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
#if !DEBUG
        // Firebase
        FirebaseApp.configure()
        
        // Sentry
        SentrySDK.start { options in
            options.dsn = "https://cc1018c2e7fe4bfa9140e409c3ae9a63@o264285.ingest.sentry.io/6365742"
            options.debug = false
            options.tracesSampleRate = 1.0
            options.enableAutoPerformanceTracking = false
            options.enableNetworkTracking = false
         }
#endif
        
        // 验证购买
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                    Defaults[.isPurchased] = true
                case .failed, .purchasing, .deferred:
                    Defaults[.isPurchased] = false
                default:
                    print("Purchase Error")
                }
            }
        }

        // 注册远程通知
        UIApplication.shared.registerForRemoteNotifications()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        CloudKitSync.shared.sync()
    }
}

