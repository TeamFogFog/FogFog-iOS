//
//  BaseViewController.swift
//  FogFog-iOS
//
//  Created by 김승찬 on 2022/11/14.
//

import UIKit

import RxSwift

protocol InteractivePopGesture: AnyObject {
    /// Pop Gesture를 막을지 결정하는 함수, default: false
    ///
    /// 특정 뷰 컨트롤러만 제스처를 막고 싶다면 BaseViewController를 상속 받은 뷰 컨트롤러에서
    /// 다음 함수를 오버라이드 한 뒤, true로 리턴해주도록 하면 된다.
    func preventInteractivePopGesture() -> Bool
}

class BaseViewController: UIViewController, InteractivePopGesture {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setStyle()
        setLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func preventInteractivePopGesture() -> Bool {
        return false
    }
    
    // MARK: UI
    
    /// Attributes (속성) 설정 메서드
    func setStyle() {
        view.backgroundColor = .white
    }
    
    /// Hierarchy, Constraints (계층 및 제약조건) 설정 메서드
    func setLayout() {}
}
