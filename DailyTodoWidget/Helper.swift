import Foundation

struct AppGroup {
    static var groupId = "group.net.darkce.checklist"
    
    static var widgetDir: URL {
        return FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: groupId)!.appendingPathComponent("Widget")
    }
}

struct WidgetHelper {
    static var list = [ListData]()
    
    static func reloadList(completion: ((_ error: Error? ) -> Void)? = nil) {
        do {
            let listFilePath = AppGroup.widgetDir.appendingPathComponent("list.json").path
            
            guard let data =  FileManager.default.contents(atPath: listFilePath) else {
                completion?(nil)
                return
            }
            let list = try JSONDecoder().decode([ListData].self, from: data)
            self.list = list
            completion?(nil)
        } catch {
            print(error)
            completion?(error)
        }
    }
}
