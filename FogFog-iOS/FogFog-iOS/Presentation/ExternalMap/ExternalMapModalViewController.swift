//
//  ExternalMapModalViewController.swift
//  FogFog-iOS
//
//  Created by taekki on 2022/11/25.
//

import UIKit

import RxCocoa
import RxSwift

final class ExternalMapModalViewController: BaseViewController {
  
  // MARK: Properties
  private let rootView = ExternalMapModalView()
  private var disposeBag = DisposeBag()
  private let viewModel: any ViewModelType
  
  // MARK: Init
  init(viewModel: some ViewModelType) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  // MARK: Life Cycle
  override func loadView() {
    self.view = rootView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    bind(viewModel: viewModel)
  }
  
  func bind(viewModel: some ViewModelType) {
    guard let viewModel = viewModel as? ExternalMapModalViewModel else {
      assertionFailure("Could not found ExternalMapModalViewModel.")
      return
    }
    
    let input = bindInput(viewModel: viewModel)
    bindOutput(viewModel: viewModel, input: input)
  }
  
  func bindInput(viewModel: ExternalMapModalViewModel) -> ExternalMapModalViewModel.Input {
    return ExternalMapModalViewModel.Input(
      kakaoMapButtonDidTap: rootView.rx.kakaoMapButtonDidTap,
      googleMapButtonDidTap: rootView.rx.googleMapButtonDidTap,
      naverMapButtonDidTap: rootView.rx.naverMapButtonDidTap,
      confirmButtonDidTap: rootView.rx.confirmButtonDidTap,
      closeButtonDidTap: rootView.rx.closeButtonDidTap
    )
  }
  
  func bindOutput(
    viewModel: ExternalMapModalViewModel,
    input: ExternalMapModalViewModel.Input
  ) {
    let output = viewModel.transform(input: input)

    output.selectedMap
      .bind(to: rootView.rx.updateViews)
      .disposed(by: disposeBag)
  }
}
