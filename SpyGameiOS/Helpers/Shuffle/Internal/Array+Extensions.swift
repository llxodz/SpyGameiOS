//
//  Array+Extensions.swift
//  SpyGameiOS
//
//  Created by Ilya Gavrilov on 28.03.2023.
//

import UIKit

extension Array {
    
    mutating func shift(withDistance distance: Int = 1) {
        let offsetIndex = distance >= 0
        ? index(startIndex, offsetBy: distance, limitedBy: endIndex)
        : index(endIndex, offsetBy: distance, limitedBy: startIndex)
        guard let index = offsetIndex else { return }
        self = Array(self[index ..< endIndex] + self[startIndex ..< index])
    }
}

extension Array where Element: Hashable {
    
    func removingDuplicates() -> [Element] {
        var dict = [Element: Bool]()
        return filter { dict.updateValue(true, forKey: $0) == nil }
    }
    
    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
