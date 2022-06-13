import XCoordinator

enum GroupRoute: Route {
    case editor
}

class GroupCoordinator: NavigationCoordinator<GroupRoute> {
    init() {
        super.init(initialRoute: .editor)
    }
    
    override func prepareTransition(for route: GroupRoute) -> NavigationTransition {
        switch route {
        case .editor:
            let viewController = GroupListViewController()
            return .push(viewController)
        }
    }
}
