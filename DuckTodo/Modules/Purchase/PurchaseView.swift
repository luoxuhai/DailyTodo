import SwiftUI

struct PurchaseView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .navigationTitle(Text("高级版"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: {
                        //
                    }){
                        Text("关闭")
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: {
                        //
                    }){
                        Text("恢复购买")
                    }
                }
            }
    }
}

struct PurchaseView_Previews: PreviewProvider {
    static var previews: some View {
        PurchaseView()
    }
}

