//
//  BaseViewController.swift
//  FogFog-iOS
//
//  Created by 김승찬 on 2022/11/14.
//

import UIKit

class BaseViewController: UIViewController {

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
    
    // MARK: UI
    
    /// Attributes (속성) 설정 메서드
    func setStyle() {
        
        view.backgroundColor = .white
    }
    
    /// Hierarchy, Constraints (계층 및 제약조건) 설정 메서드
    func setLayout() {}
}
