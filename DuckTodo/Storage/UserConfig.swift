import Defaults

enum AppearanceKeys: String, Defaults.Serializable {
    case auto = "auto"
    case light = "light"
    case dark = "dark"
}

extension Defaults.Keys {
    static let appearance = Key<AppearanceKeys>("appearance", default: .auto)
}

extension Defaults.Keys {
    static let isDebug = Key<Bool>("isDebug", default: false)
}
