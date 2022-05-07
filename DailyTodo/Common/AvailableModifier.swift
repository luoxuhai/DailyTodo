import SwiftUI

struct RefreshableModifier: ViewModifier {
    let action: @Sendable () async -> Void
    
    func body(content: Content) -> some View {
        if #available(iOS 15.0, *) {
            content.refreshable(action: action)
        } else {
            content
        }
    }
}

extension View {
    func availableRefreshable(action: @escaping @Sendable () async -> Void) -> some View {
        self.modifier(RefreshableModifier(action: action))
  }
}

/*

struct SwipeActionsModifier: ViewModifier {
    let edge: AvailableHorizontalEdge
    let allowsFullSwipe: Bool
    let content: () -> Any
    
    func body(content: Content) -> some View {
        if #available(iOS 15.0, *) {
            content.swipeActions<Any>(edge: .leading, allowsFullSwipe: false, content: content)
        } else {
            content
        }
    }
}

enum AvailableHorizontalEdge {
    case leading
    case trailing
}

extension View {
    func availableSwipeActions(edge: AvailableHorizontalEdge = .trailing, allowsFullSwipe: Bool = true, @ViewBuilder content: @escaping () -> Any) -> some View {
        self.modifier(SwipeActionsModifier(edge: edge, allowsFullSwipe: allowsFullSwipe, content: content))
    }
}
*/
