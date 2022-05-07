import Foundation
import RealmSwift
import WidgetKit

struct Checklist {
    var id: String
    var name: String
    var color: String
    var icon: String
    var order: Double
    var status: ChecklistStatus!
    var created_at: Date
    var updated_at: Date
    var item_count: Int
    var done_count: Int
}

class GroupListViewModel: ObservableObject {
    let db = DatabaseManager.shared.db
    private var notificationToken: NotificationToken?
    @Published var checklists = [Checklist]()
    @Published var isPresenteEditor = false
    // 编辑中的项目
    @Published var editingItem: Checklist? = nil
    // 当前的项目
    @Published var currentItem: Checklist? = nil
    
    init() {
       self.observe()
    }
    
    func addChecklist(name: String, color: String, complete: RealmDoneTask? = nil) {
        let maxOrder = db?.objects(ChecklistModel.self).sorted(byKeyPath: "order", ascending: false).first?.order ?? 0
        
        let obj = ChecklistModel()
        obj.id = UUID().uuidString
        obj.name = name
        obj.color = color
        obj.order = ceil(maxOrder) + ORDER_STEP
        
        DatabaseManager.shared.add(obj) {
            complete?()
        }
    }
    
    func deleteChecklist(id: String, complete: RealmDoneTask? = nil) {
        guard let group = (db?.objects(ChecklistModel.self).where {
            $0.id == id
        }.first) else {
            return
        }
        
        let tasks = db?.objects(TodoItemModel.self).where {
            $0.parent_id == group.id
        }
                
        try? self.db?.write {
            self.db?.delete(group)
            if tasks != nil {
                self.db?.delete(tasks!)
            }
            complete?()
        }
    }
}

// MARK: Fetch

extension GroupListViewModel {
    func observe() {
        let checklists = db!.objects(ChecklistModel.self)
        self.notificationToken = checklists.observe { (changes: RealmCollectionChange) in
            switch changes {
            case .initial, .update:
                self.fetchChecklists()
            default:
                print("err")
            }
        }
    }
    
    func fetchChecklists(){
        var array = [Checklist]()
        
        let results = db!.objects(ChecklistModel.self).sorted(by: \.order, ascending: false)
        
        for item in results {
            let todoItems = db!.objects(TodoItemModel.self).where {
                $0.parent_id == item.id
            }
            let itemCount = todoItems.count
            let doneCount = todoItems.where {
                $0.status == TodoItemStatus.complete
            }.count
            
            var status: ChecklistStatus = .inProgress
            if (itemCount > 0) {
                status = CGFloat(doneCount) / CGFloat(itemCount) >= 1 ? .complete : .inProgress
            }
            
            array.append(Checklist(id: item.id,
                                   name: item.name,
                                   color: item.color,
                                   icon: item.icon,
                                   order: item.order,
                                   status: status,
                                   created_at: item.created_at,
                                   updated_at: item.updated_at,
                                   item_count: itemCount,
                                   done_count: doneCount))
        }
        
        checklists = array.sorted {
            $0.status > $1.status
        }
        self.reloadWidget()
    }
}

extension GroupListViewModel {
    func updateChecklist(data: Checklist, complete: RealmDoneTask? = nil) {
        guard let object = (db!.objects(ChecklistModel.self).where {
            $0.id == data.id
        }.first) else {
            return
        }
        
        try? self.db?.write {
            if data.order != nil {
                object.order = data.order
            }
            if data.name != nil {
                object.name = data.name
            }
            if data.color != nil {
                object.color = data.color
            }
            complete?()
        }
    }
}

extension GroupListViewModel {
    func reloadWidget() {
        let widgetDataDir = AppGroup.containerURL.appendingPathComponent("Widget")
        let exist = FileManager.default.fileExists(atPath: widgetDataDir.absoluteString)
        do {
            if !exist {
                try FileManager.default.createDirectory(at: widgetDataDir, withIntermediateDirectories: true, attributes: nil)
            }
            
            var list = [ListData]()
            
            for checklist in self.checklists {
                if checklist.status == .complete || checklist.item_count == 0 {
                    continue
                }
                let progress = CGFloat(checklist.done_count) / CGFloat(checklist.item_count)
                list.append(ListData(id: checklist.id, name: checklist.name, progress: progress))
            }
            
            let data = try JSONEncoder().encode(list)
            let filePath = widgetDataDir.appendingPathComponent("list.json").path
            
            FileManager.default.createFile(atPath: filePath, contents: data)
            WidgetCenter.shared.reloadAllTimelines()
        } catch {
            print(error)
        }
    }
    
    struct ListData: Codable {
        let id: String
        let name: String
        let progress: CGFloat
    }
}


extension GroupListViewModel {
    func syncData() {
        CloudKitSync.shared.sync()
    }
}
