import Foundation
import RealmSwift

struct Checklist {
    var id: UUID
    var name: String
    var color: String
    var icon: String
    var status: ChecklistStatus!
    var created_at: Date
    var updated_at: Date
    var item_count: UInt
    var done_count: UInt
}


class ListViewModel: ObservableObject {
    let db = DatabaseManager.shared.db
    @Published var checklists = [Checklist]()

    func fetchChecklists(){
        var array = [Checklist]()
        for item in db!.objects(ChecklistModel.self) {
            array.append(Checklist(id: item.id, name: item.name, color: item.color, icon: item.icon, status: item.status, created_at: item.created_at, updated_at: item.updated_at, item_count: 0, done_count: 0))
        }
        checklists = array
    }
    
    func addChecklist(_ object: ChecklistModel? = nil) {
        let obj = ChecklistModel()
        obj.name = "我的"
        obj.color = "#FF0000"
        DatabaseManager.shared.add(obj, task: {
            print("创建数据成功")
            self.fetchChecklists()
        })
    }
}
