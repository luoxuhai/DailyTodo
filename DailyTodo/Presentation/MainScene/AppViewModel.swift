import SwiftUI
import BiometricAuthentication

enum AppState {
    case active
    case inactive
    case background
    case disconnect
}

enum BioMetricAuthType {
    case faceID
    case touchID
}

class AppViewModel: ObservableObject {
    @Published var isLock: Bool? = nil
    @Published var appState: AppState = .active
    @Published var bioMetricAuthType: BioMetricAuthType? = {
        var type: BioMetricAuthType? = nil
        if BioMetricAuthenticator.shared.faceIDAvailable() {
            type = .faceID
        } else if BioMetricAuthenticator.shared.touchIDAvailable() {
            type = .touchID
        }
        return type
    }()
}
