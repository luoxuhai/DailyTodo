import SwiftUI

struct ListCellNext: View {
    var color: Color = .tertiaryLabel
    
    var body: some View {
        Image(systemName: "chevron.right")
            .font(.system(size: 11), weight: .bold)
            .foregroundColor(color)
    }
}

struct ListCellNext_Previews: PreviewProvider {
    static var previews: some View {
        ListCellNext()
    }
}
