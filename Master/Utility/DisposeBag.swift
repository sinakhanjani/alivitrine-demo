//
//  DisposeBag.swift
//  Master
//
//  Created by Mohammad Fallah on 12/10/1398 AP.
//  Copyright © 1398 iPersianDeveloper. All rights reserved.
//

import Foundation

class DisposeBag {
    private var disposables = [Disposable]()
    
    public func insert (disposable : Disposable) {
        disposables.append(disposable)
    }
    func dispose () {
        for disposable in disposables {
            disposable.dispose()
        }
        disposables.removeAll(keepingCapacity: false)
    }
    deinit {
        dispose()
    }
}

class Disposable {
    func dispose () {
        
    }
}

extension Disposable {
    func disposed (by disposeBag : DisposeBag) {
        disposeBag.insert(disposable: self)
    }
}
