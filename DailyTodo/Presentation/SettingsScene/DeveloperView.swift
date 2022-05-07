import SwiftUI
import Defaults

struct DeveloperView: View {
    @EnvironmentObject var settingsVM: SettingsViewModel
    @Default(.isDebug) var isDebug
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    Toggle(isOn: self.$isDebug) {
                        Text("Debug 模式")
                    }
                }
                Button(action: {
                    Defaults[.isPurchased] = false
                }) {
                    Text("清除购买记录")
                }
                Button(action: {
                    Defaults.removeAll()
                }) {
                    Text("清除用户设置")
                }
                Button(action: {
                    DatabaseManager.shared.clear()
                }) {
                    Text("清除数据库")
                }
                Section {
                    HStack {
                        Text("构建版本")
                        Spacer()
                        Text(ApplicationInfo.bundleVersion)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action:{
                        settingsVM.isPresentDeveloper.toggle()
                    }) {
                        Text("返回")
                    }
                }
            }
            .navigationTitle("开发者")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct DeveloperView_Previews: PreviewProvider {
    static var previews: some View {
        DeveloperView()
    }
}
