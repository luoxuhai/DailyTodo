import Foundation
import RealmSwift

public let ORDER_STEP: Double = 10

struct TodoItem: Equatable {
    var id: String
    var parent_id: String
    var name: String
    var notes: String?
    var status: TodoItemStatus!
    var created_at: Date
    var updated_at: Date
}

class TodoItemsViewModel: ObservableObject {
    let db = DatabaseManager.shared.db
    private var notificationToken: NotificationToken?
    @Published var list = [TodoItem]()
    @Published var checklist: Checklist!
    @Published var currentTask: TodoItem!
    @Published var isPresentEditor = false

    func setChecklist(checklist: Checklist) {
        self.checklist = checklist
    }
    
    func addTodo(_ object: TodoItemModel, complete: RealmDoneTask? = nil) {
        let maxOrder = db?.objects(TodoItemModel.self).sorted(byKeyPath: "order", ascending: false).first?.order ?? 0
        object.order = maxOrder + ORDER_STEP
        
        DatabaseManager.shared.add(object, complete: {
            complete?()
        })
    }
    
    func deleteTodo(id: String, complete: RealmDoneTask? = nil) {
        guard let todoItem = (db?.objects(TodoItemModel.self).where {
            $0.id == id
        }.first) else {
            return
        }

        DatabaseManager.shared.delete(todoItem) {
            complete?()
        }
    }
    
    func updateTodo(id: String, status: TodoItemStatus? = nil, name: String? = nil, complete: RealmDoneTask? = nil) {
        guard let todoItem = (db?.objects(TodoItemModel.self).where {
            $0.id == id
        }.first) else {
            return
        }
                
        try! db!.write {
            if status != nil {
                todoItem.status = status!
            }
            if name != nil {
                todoItem.name = name!
            }
            complete?()
            print("更新数据成功")
        }
    }
    
    func completeTodo(id: String, complete: RealmDoneTask?) {
        guard let todoItem = (db?.objects(TodoItemModel.self).where {
            $0.id == id
        }.first) else {
            return
        }
        
        try! db!.write {
            todoItem.status = TodoItemStatus.complete
            complete?()
        }
    }
    
    // 重置状态到初始值
    func resetStatus(parentId: String?, complete: RealmDoneTask? = nil) {
        guard let results = (db?.objects(TodoItemModel.self).where {
            $0.parent_id == parentId ?? self.checklist.id
        }) else {
            return
        }
        
        try! db!.write {
            for item in results {
                item.status = TodoItemStatus.inProgress
            }
            complete?()
        }
    }
}

extension TodoItemsViewModel {
    func observe(_ onChange: @escaping () -> Void) {
        let todoItems = db!.objects(TodoItemModel.self)
        self.notificationToken = todoItems.observe { (changes: RealmCollectionChange) in
           
            switch changes {
            case .initial, .update:
                if self.checklist?.id != nil {
                    onChange()
                   // self.fetchTodoItems()
                }
            default:
                return
            }
        }
    }
}

extension TodoItemsViewModel {
    func fetchTodoItems(parentId: String? = nil){
        var array = [TodoItem]()
        guard let query = db?.objects(TodoItemModel.self) else {
            return
        }
        
        let results = query.where {
            $0.parent_id == (parentId ?? self.checklist.id)
        }.sorted(by: \.order).sorted(by: \.status, ascending: false)
        
        for item in results {
            array.append(TodoItem(id: item.id,
                                  parent_id: item.parent_id,
                                  name: item.name,
                                  notes: item.notes,
                                  status: item.status,
                                  created_at: item.created_at,
                                  updated_at: item.updated_at))
        }
        self.list = array
    }
    
}
