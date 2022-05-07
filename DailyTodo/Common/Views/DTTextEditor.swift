import SwiftUI
import UIKit
import Introspect

public let CRLF = "\n"

struct DTTextEditor: View {
    @Binding var text: String
    var maxLength: Int? = nil
    var shouldChangeText: ((_ text: String) -> Bool)? = nil
    var textViewDidEndEditing: ((_ textView: UITextView) -> Void)? = nil
    var textEditorDelegate = DTTextEditorDelegate()
    
    var body: some View {
        TextEditor(text: self.$text)
            .introspectTextView { textView in
                textView.returnKeyType = .done
                textView.reloadInputViews()
                self.textEditorDelegate.shouldChangeText = { text in
                    if !text.isEmpty, text != CRLF, self.maxLength != nil, textView.text.count > self.maxLength!  {
                        return false
                    }
                    
                    return self.shouldChangeText?(text) ?? true
                }
                self.textEditorDelegate.textViewDidEndEditing = self.textViewDidEndEditing
                textView.delegate = self.textEditorDelegate
            }
    }
    
    class DTTextEditorDelegate:NSObject, UITextViewDelegate {
        var shouldChangeText: ((_ text: String) -> Bool)?
        var textViewDidEndEditing : ((_ textView: UITextView) -> Void)?
        
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            return self.shouldChangeText?(text) ?? true
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            self.textViewDidEndEditing?(textView)
        }
    }
}

struct DTTextEditor_Previews: PreviewProvider {
    static var previews: some View {
        DTTextEditor(text: .constant("xdd")) { text in
            return true
        }
    }
}
