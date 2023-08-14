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
    private let viewModel: any ViewModelType
    private var disposeBag = DisposeBag()
    
    // MARK: Init
    init(viewModel: any ViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    // MARK: Life Cycle
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
