//
//  MakeNicknameViewController.swift
//  FogFog-iOS
//
//  Created by EUNJU on 2022/11/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class MakeNicknameViewController: BaseViewController {
    
    // MARK: Properties
    private let naviView = FogNavigationView()
    private let titleLabel = UILabel()
    private let nicknameTextField = FogTextField()
    private let confirmButton = UIButton()
    private let backView = UIView()
    private let errorImageView = UIImageView()
    private let errorLabel = UILabel()
    
    private let viewModel: MakeNicknameViewModel
    private let disposeBag = DisposeBag()
    private lazy var input = MakeNicknameViewModel.Input(didNicknameTextFieldChange: nicknameTextField.rx.text.orEmpty.asObservable())
    private lazy var output = viewModel.transform(input: input)
    
    
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
        
        bind()
        addTapGesture()
    }
    
    // MARK: UI
    override func setStyle() {
        view.backgroundColor = .white
        backView.backgroundColor = .grayBlack
        naviView.setTitleLabel(title: "닉네임 설정")
        [errorImageView, errorLabel].forEach { $0.isHidden = true }
        
        nicknameTextField.do {
            $0.setPlaceHolderText(placeholder: "닉네임 입력(8자리 이내)")
        }
        
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
        
        errorImageView.do {
            $0.image = FogImage.errorIcon
        }
        
        errorLabel.do {
            $0.text = "이미 존재하는 닉네임 입니다."
            $0.textColor = .etcRed
            $0.font = .pretendardM(10)
        }
    }
    
    override func setLayout() {
        view.addSubviews([naviView, titleLabel, nicknameTextField, confirmButton, backView, errorImageView, errorLabel])
        
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
        
        errorImageView.snp.makeConstraints {
            $0.top.equalTo(nicknameTextField.snp.bottom).offset(10)
            $0.leading.equalTo(nicknameTextField.snp.leading)
            $0.size.equalTo(13)
        }
        
        errorLabel.snp.makeConstraints {
            $0.leading.equalTo(errorImageView.snp.trailing).offset(5)
            $0.centerY.equalTo(errorImageView.snp.centerY)
        }
    }
    
    private func bind() {
        output.nickname
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { [weak self] nickname in
                self?.nicknameTextField.text = nickname
            })
            .disposed(by: disposeBag)
        
        output.isValid
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] result in
                [self?.errorImageView, self?.errorLabel].forEach { $0?.isHidden = result }
                if result {
                    self?.nicknameTextField.setBoderColor(color: .fogBlue)
                } else {
                    self?.nicknameTextField.setBoderColor(color: .etcRed)
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Keyboard
extension MakeNicknameViewController {
    
    private func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(_:)))
        view.addGestureRecognizer(tapGesture)
    }

    @objc
    private func hideKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
}
