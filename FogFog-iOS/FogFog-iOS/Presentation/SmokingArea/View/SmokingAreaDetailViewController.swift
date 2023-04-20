//
//  SmokingAreaDetailViewController.swift
//  FogFog-iOS
//
//  Created by 김승찬 on 2022/11/14.
//

import UIKit

import SnapKit
import Then

class SmokingAreaDetailViewController: BaseViewController {
    
    // MARK: Properties
    private let contents: any Contents
    private let contentsView: any Presentable
    
    // MARK: Initializers
    init(
        contents: any Contents,
        contentsView: any Presentable
    ) {
        self.contents = contents
        self.contentsView = contentsView
        contentsView.bind(contents)

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setStyle() {
        super.setStyle()
        
        view.backgroundColor = .clear
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        contentsView.hide(withMovement: -contentsView.viewHeight(), withDuration: 0.3)
        dismiss(animated: false)
    }
    
    override func setLayout() {
        super.setLayout()

        guard let contentsView = contentsView as? UIView else { return }
        view.addSubview(contentsView)
        
        contentsView.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview().inset(13.adjusted)
            $0.bottom.equalToSuperview().inset(20.adjustedH)
        }
    }

    func show() {
        let viewHeight = contentsView.viewHeight()
        let bottomMargin = 49.adjustedH
        contentsView.show(withMovement: viewHeight + bottomMargin, withDuration: 0.3)
    }
}

enum BottomViewType {
    case cardView
    case messageView
    
    var view: any Presentable {
        switch self {
        case .cardView:
            return SmokingAreaCardView()
        
        case .messageView:
            return SmokingAreaMessageView()
        }
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
