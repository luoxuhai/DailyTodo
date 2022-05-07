import SwiftUI

struct ListCellNext: View {
    var body: some View {
        Image(systemName: "chevron.right").foregroundColor(Color(UIColor.tertiaryLabel)).font(.system(size: 11), weight: .bold)
    }
}

struct ListCellNext_Previews: PreviewProvider {
    static var previews: some View {
        ListCellNext()
    }
}
