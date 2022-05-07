import SwiftUI
import Defaults

struct AppearanceOption {
    let key: AppearanceKeys
    let title: String
}

struct AppearanceView: View {
    @Default(.appearance) var appearance

    let options = [
        AppearanceOption(
            key: AppearanceKeys.auto, title: "跟随系统"),
        AppearanceOption(key: AppearanceKeys.light, title: "浅色"),
        AppearanceOption(key: AppearanceKeys.dark, title: "深色")
    ]
    
    var body: some View {
        List {
            ForEach(options, id: \.key) { option in
                Button(action: {
                    withAnimation(.linear(duration: 0.1)) {
                        self.appearance = option.key
                        Helper.setUserInterfaceStyle(style: option.key)
                    }
                }) {
                    HStack {
                        Text(option.title)
                        Spacer()
                        if appearance == option.key {
                            Image(systemName: "checkmark")
                                .foregroundColor(Color.blue)
                                .font(.body, weight: .bold)
                        }
                    }
                }.foregroundColor(Color.label)
            }
        }.navigationTitle(Text("外观")).navigationBarTitleDisplayMode(.inline)
    }
}

struct AppearanceView_Previews: PreviewProvider {
    static var previews: some View {
        AppearanceView()
    }
}
