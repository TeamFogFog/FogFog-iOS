//
//  SmokingAreaDetailViewController.swift
//  FogFog-iOS
//
//  Created by 김승찬 on 2022/11/14.
//

import UIKit

import SnapKit
import Then

final class SmokingAreaDetailViewController: BaseViewController {
    
    // MARK: Properties
    private let rootView = SmokeAreaDetailView()
    private weak var viewModel: MapViewModel?
    
    // MARK: Initializers
    init(viewModel: MapViewModel?) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Override Methods
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        rootView.showBottomSheet()
    }
}
