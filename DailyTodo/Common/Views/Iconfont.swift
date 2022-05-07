import SwiftUI

public enum IconfontNames: String {
    case search = "\u{e60c}"
    case lock = "\u{e63f}"
    case sync = "\u{e6d1}"
    case ellipsis = "\u{e74d}"
}

struct Iconfont: View {
    var name: IconfontNames
    var size = 14.0
    var weight: Font.Weight = .medium
    
    var body: some View {
        Text(name.rawValue)
            .font(.custom("iconfont", size: size), weight: weight)
    }
}
