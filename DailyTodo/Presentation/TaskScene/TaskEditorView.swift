import SwiftUI
import Introspect

internal let MAX_LENGTH = 500

struct TaskEditorView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var todoItemsVM: TodoItemsViewModel
    @EnvironmentObject var listVM: GroupListViewModel
    @State private var name = ""
        
    func handleSubmit() {
        if self.todoItemsVM.currentTask != nil {
            self.handleUpdateTask()
        } else {
            self.handleCreateTask()
        }
    }
    
    func handleCreateTask() {
        guard let parentId = self.listVM.currentItem?.id else {
            return
        }
        
        let task = TodoItemModel()
        task.parent_id = parentId
        task.id = UUID().uuidString
        task.name = self.name
        self.todoItemsVM.addTodo(task) {
            self.todoItemsVM.isPresentEditor = false
        }
    }
    
    func handleUpdateTask() {
        self.todoItemsVM.updateTodo(id: self.todoItemsVM.currentTask!.id,  name: self.name) {
            self.todoItemsVM.isPresentEditor = false
        }
    }
    
    func limitWordCount(value: String) {
        if value.count > MAX_LENGTH {
            self.name = "\(self.name.prefix(MAX_LENGTH))"
        }
    }
    
    var body: some View {
        HStack {
            TextField("Tasks.Editor.Name.Placeholder", text: self.$name)
                .disableAutocorrection(true)
                .onChange(of: self.name, perform: self.limitWordCount)
                .onSubmit(self.handleSubmit)
                .introspectTextField { textField in
                    textField.returnKeyType = .done
                    textField.becomeFirstResponder()
                }
                .padding(16)
            
            Spacer()
            Button(action: self.handleSubmit) {
                Image(systemName: "paperplane.circle.fill").font(.system(size: 28))
            }
            .padding(.trailing, 16)
            .disabled(self.name.count < 1)
            .animation(.default, value: self.name)
        }
        .background(colorScheme == .light ? .systemBackground : .secondarySystemBackground)
        .frame(height: 50)
        .frame(maxWidth: .infinity)
        .cornerRadius(20, corners: [.topLeft, .topRight])
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: -6)
        .onAppear {
           self.name = self.todoItemsVM.currentTask?.name ?? ""
        }
    }
}

struct TaskEditorView_Previews: PreviewProvider {
    static var previews: some View {
        TaskEditorView()
    }
}
