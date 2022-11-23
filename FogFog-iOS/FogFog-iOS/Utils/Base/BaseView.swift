//
//  BaseView.swift
//  FogFog-iOS
//
//  Created by taekki on 2022/11/20.
//

import UIKit

import RxSwift

class BaseView: UIView {
    
    var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setStyle()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setStyle() {}
    func setLayout() {}
}
