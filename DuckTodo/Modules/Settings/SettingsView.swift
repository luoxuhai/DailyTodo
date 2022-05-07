import SwiftUI
import Coordinator

struct SettingsView: View {
    @Coordinator(for: AppDestination.self) var coordinator
    @Environment(\.openURL) var openURL
    @State var hapticFeedbackEnabled = false
    @State var animationEnabled = false
    
    var body: some View {
        NavigationView {
            List {
                Button(action: {
                    
                }) {
                    
                }
                Section(header: "") {
                    Toggle(isOn: $hapticFeedbackEnabled) {
                        Text("Face ID 锁")
                    }
                    if hapticFeedbackEnabled {
                        Toggle(isOn: $hapticFeedbackEnabled) {
                            Text("隐藏小组件内容")
                        }
                    }
                    
                    Toggle(isOn: $hapticFeedbackEnabled) {
                        Text("Spotlight 快速搜索")
                    }
                    Toggle(isOn: $hapticFeedbackEnabled) {
                        Text("多设备同步")
                    }
                }
                Section {
                    NavigationLink(destination: AppearanceView()) {
                        ListCell(title: "外观")
                    }.foregroundColor(Color.label)
                    
                    ListCell(title: "语言", isLink: true, destination: UIApplication.openSettingsURLString)
                    Toggle(isOn: $hapticFeedbackEnabled) {
                        Text("触觉反馈")
                    }
                }
                Section(header: "关于") {
                    ListCell(title: "隐私政策", isLink: true, destination: DTConfig.privacyPolicy["zh_cn"])
                    ListCell(title: "反馈建议", isLink: true, destination:DTConfig.feedbackUrl)
                    ListCell(title: "给个好评", isLink: true, destination:
                                "https://apps.apple.com/app/apple-store/id\(DTConfig.appId)?action=write-review")
                    Link(destination: URL(string: "mailto:\(DTConfig.email)")!) {
                        HStack {
                            Text("联系我们")
                            Spacer()
                            Text(DTConfig.email).foregroundColor(Color(UIColor.secondaryLabel))
                            ListCellNext()
                            
                        }
                    }.foregroundColor(Color.label)
                    
                    HStack {
                        Text("版本")
                        Spacer()
                        Text("\(ApplicationInfo.version) (\(ApplicationInfo.bundleVersion))").foregroundColor(Color(UIColor.secondaryLabel))
                    }
                }
                Section(header: "更多 APP") {
                    Link(destination: URL(string: MoreAppUrls.PSpace)!) {
                        HStack {
                            Image("PSpace")
                                .resizable()
                                .frame(width: 44, height: 44)
                            
                                .cornerRadius(8)
                            VStack(alignment: .leading) {
                                Text("隐私空间").padding(.bottom, 1)
                                Text("隐藏私人图片、视频和文件").font(.subheadline).foregroundColor(Color(UIColor.secondaryLabel))
                            }
                            Spacer()
                            Image(systemName: "square.and.arrow.down")
                                .foregroundColor(Color(UIColor.systemBlue))
                        }.frame(height: 55)
                    }
                }
            }
            .animation(animationEnabled ? .default : .none)
            .onAppear() {
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    self.animationEnabled.toggle()
                }
            }
            .navigationTitle(Text("设置"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("返回") {
                        coordinator.trigger(.dismiss)
                    }
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
