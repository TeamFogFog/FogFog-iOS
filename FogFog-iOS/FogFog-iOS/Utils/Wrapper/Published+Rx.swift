//
//  Published+Rx.swift
//  FogFog-iOS
//
//  Created by taekki on 2023/06/07.
//

import RxSwift

@propertyWrapper
struct Published<Value> {
    
    private let subject = PublishSubject<Value>()
    
    var projectedValue: Observable<Value> { return subject }
    var wrappedValue: Value { didSet { valueDidChange() } }

    init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }

    private func valueDidChange() {
        subject.on(.next(wrappedValue))
    }
}
