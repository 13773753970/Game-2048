//
//  extension.swift
//  Game-2048
//
//  Created by zhoupeng on 2021/9/8.
//

import Foundation

extension Array {
    public var sample: Element? {
        guard count > 0 else {
            return nil
        }
        let randomIndex = Int(arc4random_uniform(UInt32(count)))
        return self[randomIndex]
    }
    
    func removeDuplicate() -> Array where Element: Equatable {
        return self.enumerated()
            .filter({ index, value in
                self.firstIndex(of: value) == index
            })
            .map({ _, value in
                value
            })
    }
}

extension Array where Element: Comparable {
    public var isAscend: Bool {
        if self.count < 2 {
            return true
        }
        for i in (0..<self.count - 1) {
            if self[i] >= self[i + 1] {
                return false
            }
        }
        return true
    }
}
