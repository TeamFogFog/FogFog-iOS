//
//  BaseTableViewCell.swift
//  FogFog-iOS
//
//  Created by EUNJU on 2022/12/22.
//

import UIKit

class BaseTableViewCell: UITableViewCell {

    // MARK: init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setCommonAttributes()
        setStyle()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 기본 attributes 설정 메서드 
    private func setCommonAttributes() {
        selectionStyle = .none
    }
    
    func setStyle() { }
    
    func setLayout() { }
}
