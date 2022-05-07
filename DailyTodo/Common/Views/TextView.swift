import SwiftUI

typealias TextDidEndEditing = ((_ text: String) -> Void)?
 
struct TextView: UIViewRepresentable {
 
    @Binding var text: String
    @Binding var textStyle: UIFont.TextStyle
    var isEditable = true
    var textDidEndEditing: TextDidEndEditing = nil
 
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
 
        textView.font = UIFont.preferredFont(forTextStyle: textStyle)
        textView.autocapitalizationType = .sentences
        textView.isSelectable = true
        textView.isUserInteractionEnabled = true
        textView.autocorrectionType = .no
        textView.delegate = context.coordinator
        
        return textView
    }
 
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        uiView.font = UIFont.preferredFont(forTextStyle: textStyle)
        uiView.isEditable = isEditable
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator($text, textDidEndEditing: self.textDidEndEditing)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var text: Binding<String>
        var textDidEndEditing: TextDidEndEditing = nil

        init(_ text: Binding<String>, textDidEndEditing: TextDidEndEditing) {
            self.text = text
            self.textDidEndEditing = textDidEndEditing
        }
        
        func textViewDidChange(_ textView: UITextView) {
            self.text.wrappedValue = textView.text

        }
        
        func textDidEndEditingNotification(_ textView: UITextView) {
            print("----text", textView.text)
            self.textDidEndEditing?(textView.text)
        }
    }
}

struct TextView_Previews: PreviewProvider {
    
    @State static private var text = "666"
    @State static private var textStyle = UIFont.TextStyle.body
    
    static var previews: some View {
        TextView(text: $text, textStyle: $textStyle)
    }
}
