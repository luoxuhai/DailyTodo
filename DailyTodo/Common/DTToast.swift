import Foundation
import Defaults

struct DTToast {
    static func present(title: String, message: String? = nil, preset: SPIndicatorIconPreset, haptic: SPIndicatorHaptic = .none ) {
        let _haptic = Defaults[.hapticFeedbackEnabled] ? haptic : .none
        
        DailyTodo.SPIndicator.present(title: title, message: message, preset: preset, haptic: _haptic)
    }
}

