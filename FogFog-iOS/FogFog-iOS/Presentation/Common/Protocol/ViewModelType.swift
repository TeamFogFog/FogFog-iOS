//
//  ViewModelType.swift
//  FogFog-iOS
//
//  Created by EUNJU on 2022/11/20.
//

import Foundation

import RxSwift

protocol ViewModelType {

    associatedtype Input
    associatedtype Output

    var disposeBag: DisposeBag { get set }

    func transform(input: Input) -> Output
}
