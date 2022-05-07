import SwiftUI
import Defaults
import BiometricAuthentication
import SFSafeSymbols

struct Main: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @Default(.appLockEnabled) var appLockEnabled
    @State var isPresented = true
    @Environment(\.viewController) private var viewControllerHolder: UIViewController?
    
    var body: some View {
        GroupListView()
            .onReceive(self.appViewModel.$appState) { _ in
                self.handleDelayLock()
            }
            .onAppear {
                if self.appViewModel.isLock == nil, self.appLockEnabled  {
                    self.handleLock()
                }
            }
    }
}

// MARK  解锁

extension Main {
    
    var lockView: some View {
        VStack(spacing: 10) {
            let isFaceID = self.appViewModel.bioMetricAuthType == .faceID
            let foregroundColor: Color = isFaceID ? .systemBlue : .systemRed
            
            Image(systemSymbol: isFaceID ? .faceid : .touchid)
                .foregroundColor(foregroundColor)
                .font(.system(size: 50))
            Text(self.appViewModel.bioMetricAuthType == .faceID ? "LockScreen.UnlockWithFaceId" : "LockScreen.UnlockWithTouchId")
                .foregroundColor(foregroundColor)
        }
        .onPress(perform: self.handleUnlock)
        .onReceive(self.appViewModel.$appState, perform: { appState in
            if appState == .active, self.appLockEnabled, (self.appViewModel.isLock ?? false) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.handleUnlock()
                }
            }
        })
    }
    
    // 解锁
    func handleUnlock() {
        if BioMetricAuthenticator.canAuthenticate() {
            BioMetricAuthenticator.authenticateWithBioMetrics(reason: NSLocalizedString("LockScreen.LocalAuth.PromptMessage", comment: "")) { result in
                switch result {
                case .success( _):
                    dismiss()
                default:
                    print("Authentication Failed")
                }
            }
        } else {
            dismiss()
        }
        
        func dismiss() {
            self.appViewModel.isLock = false
            self.viewControllerHolder?.dismiss(animated: true)
        }
    }
    
    func handleLock() {
        // 设备不支持生物识别
        if self.appViewModel.bioMetricAuthType == nil {
            return
        }
        self.appViewModel.isLock = true
        viewControllerHolder?.present(style: .fullScreen, animated: false) {
            lockView
        }
    }
    
    func handleDelayLock() {
        // 10 秒锁定
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            if self.appViewModel.appState == .background, self.appLockEnabled {
                self.handleLock()
            }
        }
    }
}
