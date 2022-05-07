import SwiftUI
import UIKit
import SwiftyStoreKit
import StoreKit
import Defaults
import SPAlert

struct PremiumFeature {
    let id = UUID()
    let title: LocalizedStringKey
    let icon: IconfontNames
}

struct PurchaseView: View {
    @Default(.isPurchased) var isPurchased
    @Default(.hapticFeedbackEnabled) var hapticFeedbackEnabled
    @Binding var isPresentPurchase: Bool
    @State private var productInfo: SKProduct?
    @State private var spinner: SPAlertView? = nil
    
    func handleCloseSheet() {
        self.isPresentPurchase = false
        self.spinner?.dismiss()
    }
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    Header().padding(.top, 26)
                    FeatureList().padding(.top, 26)
                }.padding(.horizontal, 32)
                
                VStack(alignment: .leading) {
                    DeclareContent()
                    HStack {
                        Link(destination: URL(string: NSLocalizedString("PrivacyPolicy.URL", comment: ""))!) {
                            Text("Settings.PrivacyPolicy")
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                        }
                        Link(destination: URL(string: NSLocalizedString("UserAgreement.URL", comment: ""))!) {
                            Text("Settings.UserAgreement")
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            self.handlePurchase()
                        }) {
                            Group {
                                if self.isPurchased {
                                    Text("Purchase.Purchased")
                                } else {
                                    Text("\(self.productInfo?.localizedPrice ?? "-") \(Text("Purchase.BuyButton"))")
                                        .redacted(if: self.productInfo == nil)
                                }
                            }.font(.subheadline, weight: .bold)
                        }
                        .frame(width: 180, height: 48)
                        .background(AppColor.primary)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .disabled(self.productInfo == nil)
                        .padding(.bottom, 10)
                        .buttonStyle(PayButtonStyle())
                        .disabled(self.isPurchased)
                        .brightness(self.isPurchased ? 0.3 : 0)
                    }
                }.padding(.horizontal, 16)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: self.handleCloseSheet){
                        ExitButtonView().frame(width: 30, height:30)
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: {
                        self.handleRestore()
                    }){
                        Text("Purchase.Restore")
                            .font(.system(size: 18), weight: .bold)
                    }.disabled(self.isPurchased)
                }
            }
        }.onAppear {
            self.fetchProductsInfo()
        }
    }
}

extension PurchaseView {
    // 获取产品信息
    func fetchProductsInfo() {
        SwiftyStoreKit.retrieveProductsInfo([DTConfig.productId]) { result in
            if let product = result.retrievedProducts.first {
                self.productInfo = product
            } else {
                DTToast.present(title: NSLocalizedString("Purchase.FetchInfo.Fail.Title", comment: ""), message: NSLocalizedString("Purchase.FetchInfo.Fail.Message", comment: ""), preset: .error)
            }
        }
    }
    
    // 恢复购买
    func handleRestore() {
        spinner?.dismiss()
        spinner = SPAlertView(title: NSLocalizedString("Purchase.Restoring", comment: ""), preset: .spinner)
        spinner?.present()
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            spinner?.dismiss()
            if results.restoredPurchases.count > 0 {
                DTToast.present(title: NSLocalizedString("Purchase.RestoreSuccess", comment: ""), preset: .done)
                self.purchaseSuccessHandler()
            } else {
                DTAlert.present(title: NSLocalizedString("Purchase.RestoreFail", comment: ""),message: NSLocalizedString("Purchase.RestoreFail.Message", comment: ""), preset: .error)
            }
        }
    }
    
    // 购买
    func handlePurchase() {
        spinner?.dismiss()
        spinner = SPAlertView(title: NSLocalizedString("Purchase.Purchasing", comment: ""), preset: .spinner)
        spinner?.dismissByTap = false
        spinner?.present()
        HapticFeedback.impact(.heavy)
        SwiftyStoreKit.purchaseProduct(DTConfig.productId, quantity: 1, atomically: true) { result in
            spinner?.dismiss()
            switch result {
            case .success:
                DTToast.present(title: NSLocalizedString("Purchase.PurchaseSuccess", comment: ""), preset: .done)
                self.purchaseSuccessHandler()
            case .error(let error):
                var errorDescription = error.localizedDescription
                switch error.code {
                case .paymentCancelled: return
                case .unknown:
                    errorDescription = "Unknown error. Please contact support"
                    fallthrough
                default:
                    DTAlert.present(title: NSLocalizedString("Purchase.PurchaseFail", comment: ""), message: errorDescription, preset: .error)
                }
            }
        }
    }
    
    func purchaseSuccessHandler() {
        self.isPurchased = true
        SPConfetti.startAnimating(.fullWidthToDown, particles: [.triangle, .arc, .heart, .star], duration: 0.1)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isPresentPurchase = false
        }
    }
}

struct Header: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text("Purchase.Title").font(.title2, weight: .bold)
                Text("Purchase.Description").font(.title2, weight: .bold)
            }
            Spacer()
        }
    }
}

let features = [
    PremiumFeature(title: "Settings.FaceID", icon: IconfontNames.lock),
  //  PremiumFeature(title: "Spotlight 快速搜索", icon: IconfontNames.search),
    PremiumFeature(title: "Settings.CloudSync", icon: IconfontNames.sync),
    PremiumFeature(title: "Purchase.MoreFeatures", icon: IconfontNames.ellipsis)
]

struct FeatureList: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                ForEach(features, id: \.id) { feature in
                    HStack {
                        Group {
                            Iconfont(name: feature.icon, size: 18)
                                .foregroundColor(AppColor.featureColor)
                        }.frame(width: 30, height: 30).background(AppColor.featureBackgroudColor).cornerRadius(15)
                        Text(feature.title)
                    }
                    
                }
            }
            Spacer()
        }
    }
}

struct DeclareContent: View {
    var body: some View {
        Group {
            Text("Purchase.Help")
            + Text("Settings.Contact").foregroundColor(Color.link)
        }
        .font(.footnote)
        .foregroundColor(.secondaryLabel)
        .onPress {
            UIApplication.shared.open(URL(string: "mailto:\(DTConfig.email)")!)
        }
    }
}

struct PurchaseView_Previews: PreviewProvider {
    @State static var isPresentPurchase = false
    
    static var previews: some View {
        PurchaseView(isPresentPurchase: $isPresentPurchase)
            .previewDevice("iPhone 12")
            .previewInterfaceOrientation(.portrait)
    }
}

