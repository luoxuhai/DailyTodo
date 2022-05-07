import Foundation


class TaskListItemViewModel: ObservableObject {
    @Published var item: TodoItem? = nil
}
