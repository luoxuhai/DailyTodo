import Foundation
import UIKit
import Defaults

struct HapticFeedback {
    static func impact(_ type: UIImpactFeedbackGenerator.FeedbackStyle) {
        if Defaults[.hapticFeedbackEnabled] {
            let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: type)
            impactFeedbackGenerator.impactOccurred()
        }
    }
    
    static func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        if Defaults[.hapticFeedbackEnabled] {
            UINotificationFeedbackGenerator().notificationOccurred(type)
        }
    }
    
    static func selection() {
        if Defaults[.hapticFeedbackEnabled] {
            UISelectionFeedbackGenerator().selectionChanged()
        }
    }
}
