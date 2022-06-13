import XCoordinator
import SwiftUI

enum AppRoute: Route {
    case list
    case setting
    case purchase
}

class AppCoordinator: NavigationCoordinator<AppRoute> {
    init() {
        super.init(initialRoute: .list)
    }
    
    override func prepareTransition(for route: AppRoute) -> NavigationTransition {
        switch route {
        case .list:
            let viewController = GroupListViewController()
            return .push(viewController)
        case .setting:
            let settingsView = UIHostingController(rootView: SettingsView()
                                                   // .environmentObject(self.appViewModel)
                .environmentObject(GroupListViewModel())
                .environmentObject(TodoItemsViewModel())
                .environmentObject(SettingsViewModel())
            )
            return .present(settingsView)
        case .purchase:
            let viewController = GroupListViewController()
            return .present(viewController)
        }
    }
}
