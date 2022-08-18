//
//  Bindable.swift
//  LeagueMobileChallenge
//
//  Created by Renato Mateus on 17/08/22.
//  Copyright © 2022 Kelvin Lau. All rights reserved.
//

import Foundation

class Bindable<T> {
    var value: T? {
        didSet {
            observer?(value)
        }
    }
    
    var observer: ((T?) -> ())?
    
    func bind(observer: @escaping (T?) -> ()) {
        self.observer = observer
    }
}
