//
//  propertyWrapper.swift
//  Game-2048
//
//  Created by 周鹏 on 2022/2/8.
//

import Foundation

final class Box<V> {
    var value: V
    init(_ value: V) {
        self.value = value
    }
}

@propertyWrapper struct Ref<V> {
    private var box: Box<V>
    var wrappedValue: V {
        get { box.value }
        nonmutating set {
            box.value = newValue
        }
    }
    init(wrappedValue value: V) {
        self.box = Box(value)
    }
}

extension Ref where V: ExpressibleByNilLiteral {
    init() {
        self.init(wrappedValue: nil)
    }
}
