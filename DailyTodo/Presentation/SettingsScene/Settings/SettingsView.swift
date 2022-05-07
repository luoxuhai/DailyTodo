import SwiftUI
import Defaults

struct SettingsView: View {
    @Environment(\.openURL) var openURL
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var settingsVM: SettingsViewModel
    @Default(.hapticFeedbackEnabled) var hapticFeedbackEnabled
    @Default(.appLockEnabled) var appLockEnabled
    @Default(.hideWidgetEnabled) var hideWidgetEnabled
    @Default(.spotlightEnabled) var spotlightEnabled
    @Default(.cloudSyncEnabled) var cloudSyncEnabled
    @Default(.isPurchased) var isPurchased
    @State var isPresentPurchase = false

    var body: some View {
        List {
            if isPurchased {
                PurchaseCardInline(isPresentPurchase: self.$isPresentPurchase)
            } else {
                PurchaseCard(isPresentPurchase: self.$isPresentPurchase)
            }
            Section {
                if self.appViewModel.bioMetricAuthType != nil {
                    Toggle(isOn: $appLockEnabled) {
                        Text(self.appViewModel.bioMetricAuthType == .faceID ? "Settings.FaceID" : "Settings.TouchID")
                    }.onChange(of: appLockEnabled) { _ in
                        if !self.isPurchased {
                            self.appLockEnabled = false
                            self.isPresentPurchase = true
                        }
                    }
                    
                    if appLockEnabled {
                        Toggle(isOn: $hideWidgetEnabled) {
                            Text("Settings.HiddinWidget")
                        }
                    }
                }
                /*
                Toggle(isOn: $spotlightEnabled) {
                    Text("Spotlight 快速搜索")
                } */
                Toggle(isOn: $cloudSyncEnabled) {
                    Text("Settings.CloudSync")
                }.onChange(of: cloudSyncEnabled) { _ in
                    if self.isPurchased {
                        CloudKitSync.shared.sync()
                    } else {
                        self.cloudSyncEnabled = false
                        self.isPresentPurchase = true
                    }
                }
            }
            
            Section {
                ListCell(title: "Settings.Appearance").onPress(navigateTo: AppearanceView())
                if SystemInfo.deviceType != .mac {
                    ListCell(title: "Settings.AppLanguage", isLink: true, destination: UIApplication.openSettingsURLString)
                }
                if SystemInfo.deviceType == .iphone {
                    Toggle(isOn: $hapticFeedbackEnabled) {
                        Text("Settings.HapticFeedback")
                    }
                }
            }
            Section(header: Text("Settings.About")) {
                ListCell(title: "Settings.PrivacyPolicy", isLink: true, destination: NSLocalizedString("PrivacyPolicy.URL", comment: ""))
                ListCell(title: "Settings.Feedback", isLink: true, destination: NSLocalizedString("Feedback.URL", comment: ""))
                ListCell(title: "Settings.GoodReview", isLink: true, destination:
                            "https://apps.apple.com/app/apple-store/id\(DTConfig.appId)?action=write-review")
                Link(destination: URL(string: "mailto:\(DTConfig.email)")!) {
                    HStack {
                        Text("Settings.Contact")
                        Spacer()
                        Text(DTConfig.email).foregroundColor(Color(UIColor.secondaryLabel))
                        ListCellNext()
                        
                    }
                }.foregroundColor(Color.label)
                
                HStack {
                    Text("Settings.AppVersion")
                    Spacer()
                    Text(ApplicationInfo.version).foregroundColor(Color(UIColor.secondaryLabel))
                }.onLongPressGesture {
                    self.handleOpenDeveloper()
                }.sheet(isPresented: self.$settingsVM.isPresentDeveloper) {
                    DeveloperView()
                }
            }
            
            Section(header: Text("MoreApps.Title")) {
                Link(destination: URL(string: MoreAppUrls.PSpace)!) {
                    HStack {
                        Image(AppImage.PSpace)
                            .resizable()
                            .frame(width: 44, height: 44)
                            .cornerRadius(8)
                        VStack(alignment: .leading) {
                            Text("MoreApps.PSpace").padding(.bottom, 1)
                            Text("MoreApps.PSpace.Desc").font(.subheadline).foregroundColor(Color(UIColor.secondaryLabel))
                        }
                        Spacer()
                        Image(systemName: "square.and.arrow.down")
                            .foregroundColor(Color(UIColor.systemBlue))
                    }.frame(height: 55)
                }
            }
        }
        .animation(.default, value: self.appLockEnabled)
        .navigationTitle(Text("Settings.Title"))
        .navigationBarTitleDisplayMode(.inline)
    }
}


extension SettingsView {
    func handleOpenDeveloper() {
        self.settingsVM.isPresentDeveloper = true
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .previewDevice("iPhone 12")
    }
}
