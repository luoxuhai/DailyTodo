import SwiftUI
import SwiftUIX
import SDCAlertView

struct GroupListItemView: View {
    @Environment(\.editMode) private var editMode
    @EnvironmentObject var listVM: GroupListViewModel
    @ObservedObject var groupListItemVM = GroupListItemViewModel()
    @State var item: Checklist
    
    func handleDeleteItem() {
        guard let index = listVM.checklists.firstIndex(where: { _item -> Bool in
            return _item.id == self.item.id
        }) else {
            return
        }
        
        self.listVM.deleteChecklist(id: listVM.checklists[index].id) {
            withAnimation {
                self.listVM.fetchChecklists()
            }
        }
    }
    
    func handleEditItem() {
        self.listVM.editingItem = self.item
        self.listVM.isPresenteEditor = true
    }
    
    var body: some View {
        let isEditing = editMode?.wrappedValue != .transient && editMode?.wrappedValue.isEditing == true
        
        HStack {
            let color = Color(UIColor(hexString: item.color))
            let progress = self.item.item_count > 0 ? CGFloat(self.item.done_count) / CGFloat(self.item.item_count) : 0
            let isEditing = editMode?.wrappedValue != .transient && editMode?.wrappedValue.isEditing == true
            
            if !isEditing {
                CircularProgress(progress)
                    .lineWidth(3)
                    .frame(width: 28)
                    .padding(.trailing, 6)
            }
            
            Text(item.name)
                .strikethrough(progress == 1)
                .font(.callout)
                .lineLimit(10)
                .padding(.horizontal, 4)
                .foregroundColor(self.item.status == .complete ? .secondaryLabel : .label)
            Spacer()
            if isEditing {
                Image(systemName: "highlighter")
                    .foregroundColor(.systemBlue)
                    .onPress {
                        self.handleEditItem()
                    }
            } else {
                Text("\(self.item.item_count)").foregroundColor(color)
                ListCellNext(color: color)
            }
        }
        .contextMenu {
            Button(action: {
                print("handleEditItem", self.item)
                self.handleEditItem()
            }) {
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
        
        .swipeActions(edge: .trailing) {
            Button {
                self.handleDeleteItem()
            } label: {
                Label("Common.Delete", systemImage: "trash")
            }
            .tint(.systemRed)
            if !isEditing {
                Button {
                    self.handleEditItem()
                } label: {
                    Label("Common.Edit", systemImage: "square.and.pencil")
                }
                .tint(.systemBlue)
            }
        }
        .frame(minHeight: SystemInfo.deviceType == .mac ? 50 : 44)
        .padding(.vertical, SystemInfo.deviceType == .mac ? 6 : 0)
        .onReceive(self.listVM.$checklists) { lists in
            if let newItem = lists.first(where: {
                $0.id == self.item.id
            }) {
                self.item = newItem
            }
        }
        .onPress(navigateTo: TaskListView(checklist: item))
    }
}
