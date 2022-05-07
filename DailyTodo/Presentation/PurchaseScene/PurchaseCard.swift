import SwiftUI
import LottieUI

struct PurchaseCard: View {
    @Binding var isPresentPurchase: Bool
    
    var body: some View {
        ZStack(alignment: .leading) {
            GeometryReader { g in
                HStack {
                    Spacer()
                    LottieView("ColorModes")
                        .loopMode(.loop)
                        .frame(width: g.size.width / 2)
                }.frame(width: g.size.width)
            }
            VStack(alignment: .leading) {
                HStack {
                    Text("Purchase.Pro").font(.title2, weight: .bold)
                    LottieView("Pro").loopMode(.loop).frame(width: 44,height: 32)
                }
                Text("Purchase.Description").font(.callout)
                Button(action: {
                    self.isPresentPurchase = true
                }) {
                    Text("Purchase.Card.Button").font(.subheadline, weight: .bold)
                }
                .frame(width: 60, height: 34)
                .background(AppColor.primary)
                .foregroundColor(.white)
                .cornerRadius(8)
            }.padding(.trailing, 50)
        }
        .frame(height: 120)
        .sheet(isPresented: $isPresentPurchase) {
            PurchaseView(isPresentPurchase: $isPresentPurchase)
        }
        .onTapGestureOnBackground {
            self.isPresentPurchase = true
        }
    }
}


struct PurchaseCardInline: View {
    @Binding var isPresentPurchase: Bool

    var body: some View {
        Button(action: {
            self.isPresentPurchase = true
        }) {
            HStack {
                LottieView("Pro").loopMode(.loop).frame(width: 44,height: 32).padding(.leading, -2)
                Text("Purchase.Pro")
                Spacer()
                ListCellNext()
            }.foregroundColor(Color.label)
        }
        .sheet(isPresented: $isPresentPurchase) {
            PurchaseView(isPresentPurchase: $isPresentPurchase)
        }
    }
}

struct PurchaseCard_Previews: PreviewProvider {
    static var previews: some View {
        PurchaseCard(isPresentPurchase: .constant(false))
        PurchaseCardInline(isPresentPurchase: .constant(false))
    }
}
