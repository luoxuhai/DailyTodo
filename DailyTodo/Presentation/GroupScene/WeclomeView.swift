import SwiftUI

struct WeclomeView: View {
    var body: some View {
        Text("Lists.WeclomeView.Title")
            .font(.title2)
            .navigationBarTitleDisplayMode(.inline)
            .foregroundColor(.secondaryLabel)
    }
}

struct WeclomeView_Previews: PreviewProvider {
    static var previews: some View {
        WeclomeView()
    }
}
