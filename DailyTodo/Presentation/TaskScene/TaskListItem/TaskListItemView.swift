import SwiftUI
import Introspect
import SDCAlertView

struct TaskListItemView: View {
    @EnvironmentObject var todoItemsVM: TodoItemsViewModel
    @EnvironmentObject var listVM: GroupListViewModel
    @State var id: String
    @State private var name: String = ""
    @State var isChecked = false
    
    func setState() {
        guard let item = self.todoItemsVM.currentTask else {
            return
        }

        self.isChecked = item.status == TodoItemStatus.complete
        self.name = item.name
    }
    
    func updateTodoItem() {
        todoItemsVM.updateTodo(id: self.id, name: self.name)
    }
    
    func handleDeleteItem() {
        todoItemsVM.deleteTodo(id: self.id)
    }
    
    func handlePresentEditor() {
        self.todoItemsVM.currentTask = self.todoItemsVM.list.first { item in
            item.id == self.id
        }
        self.todoItemsVM.isPresentEditor = true
    }
    
    var body: some View {
        let todoItem = todoItemsVM.list.first {
            $0.id == self.id
        }
        if todoItem == nil {
            EmptyView()
        } else {
            HStack {
                CheckView(isChecked: $isChecked) { value in
                    self.todoItemsVM.updateTodo(id: todoItem!.id, status: value ? TodoItemStatus.complete : TodoItemStatus.inProgress)
                    HapticFeedback.selection()
                }
                .font(.system(size: 26))
                .foregroundColor(self.isChecked ? .systemGreen : .systemBlue)
                
                Text(self.name)
                    .foregroundColor(self.isChecked ? .secondaryLabel : .label)
                    .strikethrough(self.isChecked)
                Spacer()
            }
            .contextMenu {
                Button(action: self.handlePresentEditor) {
                    Label("Common.Edit", systemImage: "square.and.pencil")
                }
                Button(role: .destructive, action: {
                    let alert = AlertController(title: NSLocalizedString("Lists.Delete.Alert.Title", comment: ""), message: NSLocalizedString("Lists.Delete.Alert.Msg", comment: ""), preferredStyle: .alert)
                    alert.addAction(AlertAction(title: NSLocalizedString("Common.Cancel", comment: ""), style: .preferred))
                    alert.addAction(AlertAction(title: NSLocalizedString("Common.OK", comment: ""), style: .normal) {_ in
                        self.handleDeleteItem()
                    })
                    alert.present()
                }) {
                    Label("Common.Delete", systemImage: "trash")
                }
            }
            .frame(minHeight: 44)
            .onPress {
               self.handlePresentEditor()
            }
            .swipeActions(edge: .trailing) {
                Button {
                    handleDeleteItem()
                } label: {
                    Label("Common.Delete", systemImage: "trash")
                }
                .tint(.red)
                
                Button {
                    self.handlePresentEditor()
                } label: {
                    Label("Common.Edit", systemImage: "info.circle")
                }
                .tint(.systemBlue)
            }
            .onReceive(self.todoItemsVM.$list, perform: { result in
                self.todoItemsVM.currentTask = result.first { item in
                    item.id == self.id
                }
                self.setState()
            })
        }
    }
}
