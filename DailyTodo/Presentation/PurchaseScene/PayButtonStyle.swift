import SwiftUI

struct PayButtonStyle: ButtonStyle {
    public func makeBody(configuration: ButtonStyle.Configuration) -> some View {
        
        configuration.label
            .compositingGroup()
            .opacity(configuration.isPressed ? 0.7 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.default)
    }
}
