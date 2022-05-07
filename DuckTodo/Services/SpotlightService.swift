import Foundation
import CoreSpotlight
import UniformTypeIdentifiers
import UIKit

class SpotlightService {
    static let shared = SpotlightService()
    var searchableItems: [CSSearchableItem] = []
    
    func start() {
        creatIndex()
        saveIndex()
    }
    
    func creatIndex() {
        for i in 1..<7 {
            let attributeSet = CSSearchableItemAttributeSet(itemContentType: UTType.image.identifier)
            attributeSet.title = "hangge.com 系列文章\(i)"
            attributeSet.contentDescription = "这个是一段简单的描述"
            attributeSet.keywords = ["article\(i)", "swift"]
           // attributeSet.thumbnailData = UIImage(named: "a")!.pngData()
            let item = CSSearchableItem(uniqueIdentifier: "\(i)",
                domainIdentifier: "group1", attributeSet: attributeSet)
            self.searchableItems.append(item)
        }
    }
    
    func saveIndex() {
        CSSearchableIndex.default()
            .indexSearchableItems(self.searchableItems, completionHandler: { (error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                print("索引添加成功!")
            }
        })
    }
}
