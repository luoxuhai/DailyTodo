import SwiftUI

public struct CircularProgress: View {
    public let value: CGFloat

    private var checkmarkSize: CGFloat = 13
    private var lineWidth: CGFloat = 2

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
                if self.value >= 1 {
                    Image(systemSymbol: .checkmark).font(.system(size: checkmarkSize, weight: .bold, design: .rounded))
                        .foregroundColor(.systemGreen)
                } else {
                    Text("\(Int(self.value * 100))")
                }
            }
            .font(.system(size: 12))
            .foregroundColor(self.value >= 1 ? .systemGreen : .systemBlue)
        }
    }
    
    /// Sets the line width of the view.
    public func lineWidth(_ lineWidth: CGFloat) -> CircularProgress {
        then {
            $0.lineWidth = lineWidth
        }
    }
    
    /// Sets the line width of the view.
    public func checkmarkSize(_ checkmarkSize: CGFloat) -> CircularProgress {
        then {
            $0.checkmarkSize = checkmarkSize
        }
    }
}

struct CircularProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        CircularProgress(0.8).frame(width: 50, height: 50)
    }
}
