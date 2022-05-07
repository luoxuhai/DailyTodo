import SwiftUI
import UIKit
import Introspect

let COLOR_SIZE: CGFloat = 40
let colors: [String] = [
    "#FF9500",
    "#FFCC00",
    "#34C759",
    "#FF3B30",
    "#5AC8FA",
    "#007AFF",
    "#5E5CE6",
    "#AF52DE",
    "#FF2D55",
    "#F43F5E",
    
    "#D946EF",
    "#0891B2",
    "#0D9488",
    "#EA580C",
    "#34D399",
    "#A3E635",
    "#2DD4BF",
    "#22D3EE",
    "#818CF8",
    "#7E22CE",
    "#FB7185",
]

let columns = [GridItem(.adaptive(minimum: COLOR_SIZE, maximum: COLOR_SIZE))]

struct GroupEditorView: View {
    @EnvironmentObject var listVM: GroupListViewModel
    @State var name = ""
    @State var currentColor = colors.first!

    let maxLength = 200
    
    func handleCreate() {
        listVM.addChecklist(name: self.name, color: self.currentColor) {
            DTToast.present(title: "已创建新列表", preset: .done)
            self.closeEditor()
        }
    }
    
    func handleUpdate() {
        guard var data = self.listVM.editingItem else {
            return
        }
        
        data.name = self.name
        data.color = self.currentColor
        
        self.listVM.updateChecklist(data: data) {
            self.closeEditor()
        }
    }
    
    func closeEditor() {
        self.listVM.isPresenteEditor = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            self.listVM.editingItem = nil
        }
    }
    
    func limitWordCount(value: String) {
        if value.count > maxLength {
            self.name = "\(self.name.prefix(maxLength))"
        }
    }

    var body: some View {
        let isCreate = self.listVM.editingItem == nil
        let navigationTitle: LocalizedStringKey = isCreate ? "Lists.Editor.Create.Title" : "Lists.Editor.Update.Title"
        let disabledSave = self.name.isEmptyWithout
        
        NavigationView {
            List {
                Section {
                    TextField("Lists.Editor.Name.Placeholder", text: self.$name)
                        .disableAutocorrection(true)
                        .foregroundColor(Color(UIColor(hexString: currentColor)))
                        .onChange(of: self.name, perform: self.limitWordCount)
                        .introspectTextField { textField in
                            textField.returnKeyType = .done
                            textField.becomeFirstResponder()
                        }
                }
                Section {
                    LazyVGrid(columns: columns) {
                        ForEach(colors, id: \.self) { color in
                            Color(UIColor(hexString: color))
                                .cornerRadius(25)
                                .frame(width: COLOR_SIZE, height: COLOR_SIZE)
                                .overlay(currentColor == color ? Image(systemName: "checkmark").foregroundColor(.white).font(.system(size: 14, weight: .bold, design: .default)) : nil)
                                .onPress {
                                    self.currentColor = color
                                }
                        }
                    }.padding(.vertical, 6)
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.large)
            .onReceive(self.listVM.$editingItem) { editingItem in
                self.name = editingItem?.name ?? ""
                self.currentColor = editingItem?.color ?? self.currentColor
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: self.closeEditor) {
                        Text("Common.Cancel")
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: isCreate ? self.handleCreate : self.handleUpdate ) {
                        Text("Common.Save")
                    }
                    .disabled(disabledSave)
                    .animation(.default, value: disabledSave)
                }
            }
        }
    }
}

struct GroupEditorView_Previews: PreviewProvider {
    static var previews: some View {
        GroupEditorView()
    }
}
