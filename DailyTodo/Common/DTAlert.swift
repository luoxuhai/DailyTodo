import SPAlert
import Defaults

struct DTAlert {
    static func present(title: String, message: String?, preset: SPAlertIconPreset, haptic: SPAlertHaptic = .none) {
        let _haptic = Defaults[.hapticFeedbackEnabled] ? haptic : .none
        
        SPAlert.present(title: title, message: message, preset: preset, haptic: _haptic)
    }
}
