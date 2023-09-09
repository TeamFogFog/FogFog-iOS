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
    private let navigationView = FogNavigationView()
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
        
        registerCell()
    }
    
    // MARK: UI
    override func setStyle() {
        view.backgroundColor = .white
        
        navigationView.setTitle("설정")
        
        logoutButton.do {
            $0.setTitle("로그아웃", for: .normal)
            $0.setTitleColor(.grayGray6, for: .normal)
            $0.titleLabel?.font = .pretendardM(14)
            $0.backgroundColor = .grayGray10
        }
        
        settingTableView.do {
            $0.separatorStyle = .none
            $0.backgroundColor = .white
            $0.rowHeight = UITableView.automaticDimension
            $0.isScrollEnabled = false
        }
        
        bindSettingTableView()
    }
    
    override func setLayout() {
        view.addSubviews([navigationView, settingTableView, logoutButton])
        
        navigationView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(92)
        }
        
        settingTableView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        logoutButton.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(64)
        }
    }
    
    private func bindSettingTableView() {
        let list = Observable.just(["", "약관 및 정책", "서비스 이용약관", "개인정보 처리 방침", "위치기반서비스 이용약관", "기타", "회원 탈퇴"])
        
        list.bind(to: settingTableView.rx.items) { (tableView, index, item) in
            let indexPath = IndexPath(row: index, section: 0)
            guard let editNicknameCell = tableView.dequeueReusableCell(withIdentifier: SettingNicknameTableViewCell.className, for: indexPath) as? SettingNicknameTableViewCell,
                  let titleCell = tableView.dequeueReusableCell(withIdentifier: SettingTitleTableViewCell.className, for: indexPath) as? SettingTitleTableViewCell,
                  let settingCell = tableView.dequeueReusableCell(withIdentifier: SettingListTableViewCell.className, for: indexPath) as? SettingListTableViewCell else { return UITableViewCell() }
            
            switch indexPath.row {
            case 0:
                let input = SettingViewModel.Input(viewWillAppear: self.rx.viewWillAppear,
                                                   tapBackButton: self.navigationView.backButtonDidTap(),
                                                   tapEditNicknameButton: editNicknameCell.editNicknameButtonDidTap())
                let output = self.viewModel.transform(input: input)
                
                output.didBackButtonTapped
                    .emit()
                    .disposed(by: self.disposeBag)
                
                output.didEditNicknameButtonTapped
                    .emit()
                    .disposed(by: self.disposeBag)
                
                output.nickname
                    .subscribe(onNext: { result in
                        editNicknameCell.setNickname(result)
                    })
                    .disposed(by: self.disposeBag)
                
                return editNicknameCell
            case 1:
                titleCell.lineView.isHidden = true
                titleCell.setData(title: item)
                return titleCell
            case 5:
                titleCell.setData(title: item)
                return titleCell
            default:
                settingCell.setData(title: item)
                return settingCell
            }
        }
        .disposed(by: disposeBag)
        
    }
    
    // MARK: Custom Methods
    private func registerCell() {
        settingTableView.register(SettingNicknameTableViewCell.self, forCellReuseIdentifier: SettingNicknameTableViewCell.className)
        settingTableView.register(SettingTitleTableViewCell.self, forCellReuseIdentifier: SettingTitleTableViewCell.className)
        settingTableView.register(SettingListTableViewCell.self, forCellReuseIdentifier: SettingListTableViewCell.className)
    }
}
