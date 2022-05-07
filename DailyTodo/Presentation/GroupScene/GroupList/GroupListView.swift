import SwiftUI
import WidgetKit

struct GroupListView: View {
    @EnvironmentObject var listVM: GroupListViewModel
    @Environment(\.editMode) private var editMode
    
    var body: some View {
        NavigationView {
            Group {
                if listVM.checklists.isEmpty {
                    Text("Lists.Empty")
                        .background(.systemBackground)
                        .foregroundColor(.secondaryLabel)
                } else {
                    List {
                        ForEach(listVM.checklists, id: \.id) { item in
                            GroupListItemView(item: item)
                        }
                        .onDelete(perform: { offsets in
                            self.handleDeleteItem(index: offsets.last! - 1)
                        })
                        .onMove(perform: moveItem)
                    }
                    .refreshable {
                        self.listVM.syncData()
                    }
                    .listStyle(.sidebar)
                }
            }
            .onAppear() {
                listVM.fetchChecklists()
            }
            .navigationTitle(Text("Lists.Title"))
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    EditButton()
                }
                
                ToolbarItem(placement: .bottomBar) {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemSymbol: .gearshape)
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Button(action: {
                        self.listVM.isPresenteEditor = true
                    }) {
                        Text("\(Image(systemSymbol: .plusCircleFill)) \(Text("Lists.Add"))")
                    }
                    .sheet(isPresented: self.$listVM.isPresenteEditor) {
                        GroupEditorView()
                    }
                }
            }
            .background(Color(UIColor.secondarySystemBackground))
            WeclomeView()
        }
    }
}

extension GroupListView {
      /// 移动
    func moveItem(from source: IndexSet, to destination: Int) {
        let currentIndex = source.last!
        if currentIndex == destination {
            return
        }
        
        let isUp = source.last! > destination
        var currentItem = listVM.checklists[currentIndex]
        let destIndex = isUp ? destination : destination - 1
        let destItem = listVM.checklists[destIndex]
        var currentOrder: Double
        
        if destination == 0 {
            currentOrder = destItem.order + ORDER_STEP
        } else if destination == listVM.checklists.endIndex {
            currentOrder = destItem.order / 2
        } else {
            let nextOrder = listVM.checklists[isUp ?  destIndex - 1 : destIndex + 1].order
            currentOrder = (destItem.order + nextOrder) / 2
        }
        
        currentItem.order = currentOrder
        
        self.listVM.updateChecklist(data: currentItem)
    }

    /// 删除
    func handleDeleteItem(index: Int) {
        self.listVM.deleteChecklist(id: listVM.checklists[index].id)
    }
    
    func refetchWithAnimation() {
        withAnimation {
            self.listVM.fetchChecklists()
        }
    }
}

struct GroupListView_Previews: PreviewProvider {
    static var previews: some View {
        GroupListView().environmentObject(GroupListViewModel())
    }
}
