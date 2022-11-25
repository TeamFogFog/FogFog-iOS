//
//  MakeNicknameViewController.swift
//  FogFog-iOS
//
//  Created by EUNJU on 2022/11/24.
//

import UIKit

import SnapKit
import Then

final class MakeNicknameViewController: BaseViewController {
    
    // MARK: Properties
    private let naviView = FogNavigationView()
    private let titleLabel = UILabel()
    private let nicknameTextField = FogTextField()
    private let confirmButton = UIButton()
    private let backView = UIView()
    
    private weak var viewModel: MakeNicknameViewModel?
    
    // MARK: Init
    init(viewModel: MakeNicknameViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("MakeNicknameViewController Error!")
    }

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: UI
    override func setStyle() {
        view.backgroundColor = .white
        backView.backgroundColor = .grayBlack
        naviView.setTitleLabel(title: "닉네임 설정")
        nicknameTextField.setPlaceHolderText(placeholder: "닉네임 입력(8자리 이내)")
        
        titleLabel.do {
            $0.text = "포그포그에서 사용할\n닉네임을 입력해주세요"
            $0.numberOfLines = 2
            $0.font = .pretendardB(24)
            $0.textAlignment = .left
        }
        
        confirmButton.do {
            $0.setTitle("확인", for: .normal)
            $0.titleLabel?.font = .pretendardB(18)
            $0.titleLabel?.textColor = .white
            $0.backgroundColor = .grayBlack
        }
    }
    
    override func setLayout() {
        view.addSubviews([naviView, titleLabel, nicknameTextField, confirmButton, backView])
        
        naviView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(92)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(naviView.snp.bottom).offset(52)
            $0.leading.equalToSuperview().inset(16)
        }
        
        nicknameTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(41)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(54)
        }
        
        confirmButton.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(54)
        }
        
        backView.snp.makeConstraints {
            $0.top.equalTo(confirmButton.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
