import SwiftUI
import Coordinator

enum AppDestination {
    case settings
    case todoItems
    case list
    case purchase
    case dismiss
    case pop
    case appearance
}

class AppCoordinator: UIWindowCoordinator<AppDestination> {
    override func transition(for route: AppDestination) -> ViewTransition {
        switch route {
        case .settings:
            return .push(SettingsView())
        case .purchase:
            return .present(PurchaseView())
        case .todoItems:
            return .push(TodoItemsView())
        case .appearance:
            return .push(AppearanceView())
        case .list:
            return .popToRootOrDismiss
        case .dismiss:
            return .dismiss
        case .pop:
            return .pop
        }
    }
}

struct Main: View {
    @StateObject var coordinator = AppCoordinator()

    var body: some View {
        ListView().coordinator(coordinator)
    }
}

struct Main_Previews: PreviewProvider {
    static var previews: some View {
        Main()
    }
}
