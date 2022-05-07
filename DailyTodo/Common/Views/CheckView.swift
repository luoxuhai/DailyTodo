import SwiftUI

struct CheckView: View {
    @Binding var isChecked: Bool
    var onCheckChange: ((_ value: Bool) -> Void)? = nil
    
    init(isChecked: Binding<Bool>, onCheckChange: @escaping ((_ value: Bool) -> Void)) {
        self._isChecked = isChecked
        self.onCheckChange = onCheckChange
    }

    var body: some View {
        Group {
            if isChecked {
                Image(systemName: "checkmark.circle.fill")
            } else {
                Image(systemName: "circle")
            }
        }.onPress {
            self.isChecked.toggle()
            self.onCheckChange?(self.isChecked)
        }
    }
}

struct CheckView_Previews: PreviewProvider {
    @State static var isChecked = false
    
    static var previews: some View {
        CheckView(isChecked: $isChecked) { value in
            
        }
    }
}
