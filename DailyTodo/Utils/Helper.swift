import Foundation
import UIKit

struct Helper {
    
}

extension Helper {
    static func setUserInterfaceStyle(style: AppearanceKeys) {
        let scenes = UIApplication.shared.connectedScenes
        guard let window = (scenes.first as? UIWindowScene)?.windows.first else {
            return
        }
        
        switch style {
        case .light:
            window.overrideUserInterfaceStyle = .light
        case .dark:
            window.overrideUserInterfaceStyle = .dark
        default:
            window.overrideUserInterfaceStyle = .unspecified
        }
    }
}
