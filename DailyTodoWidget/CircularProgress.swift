import SwiftUI

public struct CircularProgress: View {
    public let value: CGFloat

    private var lineWidth: CGFloat = 2.5

    public init(_ value: CGFloat) {
        assert(value >= 0 && value <= 1)
        self.value = value
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                Circle()
                    .stroke(lineWidth: self.lineWidth)
                    .opacity(0.3)
                Circle()
                    .trim(from: 0, to: self.value)
                    .stroke(lineWidth: self.lineWidth)
                    .rotationEffect(.degrees(-90))
            }
            .font(.system(size: 12))
        }
    }
}

struct CircularProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        CircularProgress(0.8).frame(width: 50, height: 50)
    }
}
