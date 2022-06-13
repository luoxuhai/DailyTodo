import UIKit
import PinLayout
import SwiftUI


class GroupListToolbarView {
    var vc: UIViewController?

     init(_ vc: UIViewController) {
        self.vc = vc
        self.createToolbar()
    }
    
    required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
    }
        
    private func createToolbar() {
        let systemButton = UIBarButtonItem(image: UIImage(systemSymbol: .gearshape)
                                           , style: .plain, target: self.vc, action: #selector(handlePresentSetting))
        
        let additionButton = UIButton(type: .system)
        additionButton.setImage(.plusCircleFill, for: .normal)
        additionButton.setTitle(LocalizedString("Lists.Add"), for: .normal)
        additionButton.addTarget(self.vc, action: #selector(handleAddClick), for: .touchUpInside)
        let flexibleButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        self.vc?.navigationController?.isToolbarHidden = false;
        self.vc?.toolbarItems = [systemButton, flexibleButton, UIBarButtonItem(customView: additionButton)]
   }
    
    @objc func handlePresentSetting() {
        
    }
    
    @objc func handleAddClick() {
        
    }
}
