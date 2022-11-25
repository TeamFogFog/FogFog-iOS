//
//  RoadPopUpViewController.swift
//  FogFog-iOS
//
//  Created by taekki on 2022/11/25.
//

import UIKit

import RxCocoa
import RxSwift

final class RoadPopUpViewController: BaseViewController {
    
    private let rootView = RoadPopUpView()
    private let viewModel: any ViewModelType
    private var disposeBag = DisposeBag()
    
    init(viewModel: any ViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
}

extension RoadPopUpViewController {
    
    func bind() {
        guard
            let kakaoButton = rootView.buttonStack.arrangedSubviews[0].subviews.first(where: { $0 is UIButton }) as? UIButton,
            let googleButton = rootView.buttonStack.arrangedSubviews[1].subviews.first(where: { $0 is UIButton }) as? UIButton,
            let naverButton = rootView.buttonStack.arrangedSubviews[2].subviews.first(where: { $0 is UIButton }) as? UIButton
        else { return }

        guard let viewModel = viewModel as? RoadPopUpViewModel else { return }
        let input = RoadPopUpViewModel.Input(
            kakaoButtonTrigger: kakaoButton.rx.tap,
            googleButtonTrigger: googleButton.rx.tap,
            naverButtonTrigger: naverButton.rx.tap,
            confirmButtonTrigger: rootView.confirmButton.button.rx.tap,
            closeButtonTrigger: rootView.closeButton.rx.tap
        )
        let output = viewModel.transform(input: input)
        
        output.didSelectMap
            .bind(with: self) { viewController, mapType in
                viewController.rootView.select(to: mapType)
            }
            .disposed(by: disposeBag)
        
        output.didConfirm
            .bind(with: self) { viewController, _ in
                viewController.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        output.didCancel
            .bind(with: self) { viewController, _ in
                viewController.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
}
