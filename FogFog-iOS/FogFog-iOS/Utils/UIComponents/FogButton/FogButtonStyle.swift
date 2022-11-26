//
//  FogButtonStyle.swift
//  FogFog-iOS
//
//  Created by taekki on 2022/11/25.
//

import UIKit

struct FogButtonStyle {
    let borderColor: UIColor
    let titleColor: UIColor
    let backgroundColor: UIColor
    let font: UIFont
    let leftImage: UIImage?
}

extension FogButtonStyle {
    
    static let unselected = FogButtonStyle(
        borderColor: .grayGray9,
        titleColor: .grayGray3,
        backgroundColor: .grayWhite,
        font: .pretendardM(16),
        leftImage: nil
    )
    
    static let selected = FogButtonStyle(
        borderColor: .fogBlue,
        titleColor: .fogBlue,
        backgroundColor: .mainBlue8,
        font: .pretendardB(16),
        leftImage: .checkmark
    )
    
    static let normal = FogButtonStyle(
        borderColor: .grayBlack,
        titleColor: .grayWhite,
        backgroundColor: .grayBlack,
        font: .pretendardB(18),
        leftImage: nil
    )
}
