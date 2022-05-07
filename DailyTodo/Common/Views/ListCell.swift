import SwiftUI

struct ListCell: View {
    var title: LocalizedStringKey
    var isShowNext = true
    var isLink = false
    var destination: String?
    
    var body: some View {
        if isLink {
            Link(destination: URL(string: destination!)!) {
                BaseCell
            }.foregroundColor(Color.label)
        } else {
            BaseCell
        }
    }
    
    var BaseCell: some View {
        HStack {
            Text(title)
            Spacer()
            if isShowNext {
                ListCellNext()
            }
        }
    }
}
