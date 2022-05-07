import SwiftUI
import Introspect


struct TaskListView: View {
    @EnvironmentObject var todoItemsVM: TodoItemsViewModel
    @EnvironmentObject var listVM: GroupListViewModel
    @State var animation = false
    var checklist: Checklist
    
    func refetchWithAnimation() {
        todoItemsVM.fetchTodoItems()
    }
    
    func initTasks() {
        todoItemsVM.setChecklist(checklist: checklist)
        self.todoItemsVM.observe {
            self.refetchWithAnimation()
        }
    }
    
    func onAppear() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.animation = true
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                if todoItemsVM.list.isEmpty {
                    Text("Tasks.Empty")
                        .background(.systemBackground)
                        .foregroundColor(.secondaryLabel)
                } else {
                    List {
                        ForEach(todoItemsVM.list, id: \.id) { item in
                            TaskListItemView(id: item.id)
                        }
                    }
                    .listStyle(.plain)
                    .animation(.default, value: self.todoItemsVM.list)
                }
            }
            .disabled(self.todoItemsVM.isPresentEditor)
            .onTapGestureOnBackground {
                self.todoItemsVM.isPresentEditor = false
            }
            if self.todoItemsVM.isPresentEditor {
                TaskEditorView()
            }
        }
        .navigationTitle(checklist.name)
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Group {
                    Button(action: {
                        todoItemsVM.resetStatus(parentId: checklist.id)
                    }) {
                        Text("TodoItems.Reset")
                    }
                    Spacer()
                    Button(action: {
                        self.todoItemsVM.currentTask = nil
                        self.todoItemsVM.isPresentEditor = true
                    }) {
                        Text("\(Image(systemName: "plus.circle.fill")) \(Text("TodoItems.Add"))")
                    }
                }
                .visible(!self.todoItemsVM.isPresentEditor)
                .animation(.default, value: self.todoItemsVM.isPresentEditor)
            }
        }
        .onAppear {
            self.onAppear()
        }
        .onDisappear {
            self.listVM.currentItem = nil
            self.todoItemsVM.isPresentEditor = false
        }
        .onReceive(self.listVM.$currentItem) { list in
            self.initTasks()
            if list?.id == self.checklist.id {
                self.onAppear()
            } else {
                self.animation = false
            }
        }
    }
}


struct TaskListView_Previews: PreviewProvider {
    static var d = Checklist(
        id: UUID().uuidString,
        name: "dede",
        color: "dede",
        icon: "dede",
        order: 10,
        created_at: Date(),
        updated_at: Date(),
        item_count: 5,
        done_count: 5)
    
    static var previews: some View {
        TaskListView(checklist: d).environmentObject(TodoItemsViewModel())
    }
}
