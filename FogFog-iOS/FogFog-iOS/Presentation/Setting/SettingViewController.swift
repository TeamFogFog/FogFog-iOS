//
//  SettingViewController.swift
//  FogFog-iOS
//
//  Created by EUNJU on 2022/12/22.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class SettingViewController: BaseViewController {

    // MARK: Properties
    private let naviView = FogNavigationView()
    private let settingTableView = UITableView()
    private let logoutButton = UIButton()
    
    private let viewModel: SettingViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: Init
    init(viewModel: SettingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("SettingViewController Error!")
    }

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    // MARK: UI
    override func setStyle() {
        view.backgroundColor = .grayGray10
        naviView.setTitle("설정")
        
        logoutButton.do {
            $0.setTitle("로그아웃", for: .normal)
            $0.setTitleColor(.grayGray6, for: .normal)
            $0.titleLabel?.font = .pretendardM(14)
            $0.backgroundColor = .grayGray10
        }
    }
    
    override func setLayout() {
        view.addSubviews([naviView, settingTableView, logoutButton])
        
        naviView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(92)
        }
        
        settingTableView.snp.makeConstraints {
            $0.top.equalTo(naviView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        logoutButton.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(64)
        }
    }
}
