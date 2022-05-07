import SwiftUI
import Coordinator

struct ListView: View {
    @State private var isShowSettings = false
    @State private var refresh = UUID()
    @StateObject private var listViewModel = ListViewModel()
    @Coordinator(for: AppDestination.self) var coordinator

    init() {
        if #available(iOS 15.0, *) {
           UIToolbar.appearance().isTranslucent = true
        } else {
            // Fallback on earlier versions
        }
          //  UITableView.appearance().backgroundColor = .clear
     }

    var body: some View {
        NavigationView {
            Checklists()
                .navigationTitle(Text("待办鸭"))
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        EditButton()
                    }
                    
                    ToolbarItem(placement: .bottomBar) {
                     //   NavigationLink(destination: Sett, label: <#T##() -> _#>)
                        Button(action: {
                            isShowSettings.toggle()
                           // coordinator.trigger(.settings)
                        }) {
                            Image(systemName: "gearshape")
                        }.fullScreenCover(isPresented: $isShowSettings) {
                            SettingsView()
                        }
                    }
                    ToolbarItem(placement: .bottomBar) {
                        Button(action: {
                            listViewModel.addChecklist()
                            listViewModel.fetchChecklists()
                        }) {
                            Text("添加列表")
                        }
                    }
                }
                .id(refresh)
                .background(Color(UIColor.secondarySystemBackground))
        }
    }
}

struct Checklists: View {
    @StateObject private var listViewModel = ListViewModel()
    @Coordinator(for: AppDestination.self) var coordinator

    /// 移动
    func moveItem(from source: IndexSet, to destination: Int) {
        listViewModel.fetchChecklists()
    }

    /// 删除
    func deleteItem(at offsets: IndexSet) {
        listViewModel.fetchChecklists()
    }
    
    var body: some View {
        if #available(iOS 15.0, *) {
            List {
                ForEach(listViewModel.checklists, id: \.id) { item in
                    ChecklistItemView(item: item)
                }
                .onDelete(perform: deleteItem)
                .onMove(perform: moveItem)
                .swipeActions(edge: .leading) {
                    Button {
                        
                    } label: {
                        Label("完成", systemImage: "checkmark.circle")
                    }
                    .tint(.green)
                }
                .swipeActions(edge: .trailing) {
                    Button {
                        
                    } label: {
                        Label("删除", systemImage: "trash")
                    }
                    .tint(.red)
                    Button {
                        
                    } label: {
                        Label("编辑", systemImage: "square.and.pencil")
                    }
                    .tint(.blue)
                }
            }
            .onAppear() {
                listViewModel.fetchChecklists()
                print("--------onAppear-------",listViewModel.checklists.count)
            }.listStyle(.insetGrouped)
                .refreshable {
                    listViewModel.fetchChecklists()
                }
        } else {
            // Fallback on earlier versions
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
