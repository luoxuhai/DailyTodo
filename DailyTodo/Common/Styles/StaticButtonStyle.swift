import SwiftUI

// 禁用NavigationLink、Button默认点击高亮效果
struct StaticButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}
