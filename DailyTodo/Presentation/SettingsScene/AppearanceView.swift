import SwiftUI
import Defaults

struct AppearanceOption {
    let key: AppearanceKeys
    let title: LocalizedStringKey
}

struct AppearanceView: View {
    @Default(.appearance) var appearance

    let options = [
        AppearanceOption(
            key: AppearanceKeys.auto, title: "Appearance.Automatic"),
        AppearanceOption(key: AppearanceKeys.light, title: "Appearance.Light"),
        AppearanceOption(key: AppearanceKeys.dark, title: "Appearance.Dark")
    ]
    
    var body: some View {
        List {
            ForEach(options, id: \.key) { option in
                Button(action: {
                    self.appearance = option.key
                    Helper.setUserInterfaceStyle(style: option.key)
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
        }.navigationTitle(Text("Settings.Appearance")).navigationBarTitleDisplayMode(.inline)
    }
}

struct AppearanceView_Previews: PreviewProvider {
    static var previews: some View {
        AppearanceView()
    }
}
