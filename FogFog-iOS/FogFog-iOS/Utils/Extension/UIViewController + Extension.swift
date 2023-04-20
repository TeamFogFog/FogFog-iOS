//
//  UIViewController + Extension.swift
//  FogFog-iOS
//
//  Created by EUNJU on 2022/12/22.
//

import UIKit.UIViewController

extension UIViewController {
    
    static var className: String {
        NSStringFromClass(self.classForCoder()).components(separatedBy: ".").last!
    }
    
    var className: String {
        NSStringFromClass(self.classForCoder).components(separatedBy: ".").last!
    }
}

extension UIViewController {
    
    func showBottomView(_ withContents: some Contents, _ viewType: BottomViewType) {
        let viewController = SmokingAreaDetailViewController(contents: withContents, contentsView: viewType.view)
        viewController.modalPresentationStyle = .overFullScreen
        viewController.view.backgroundColor = .clear
        present(viewController, animated: false) {
            viewController.show()
        }
    }
}
