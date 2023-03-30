//
//  StringUtils.swift
//  SpyGameiOS
//
//  Created by Ilya Gavrilov on 28.03.2023.
//

import UIKit

// swiftlint:disable line_length
enum StringUtils {
    
    static func createInvalidUpdateErrorString(newCount: Int,
                                               oldCount: Int,
                                               insertedCount: Int = 0,
                                               deletedCount: Int = 0) -> String {
        return "Invalid update: invalid number of cards. The number of cards contained in the card stack after the update (\(newCount)) must be equal to the number of cards contained in the card stack before the update (\(oldCount)), plus or minus the number of cards inserted or deleted (\(insertedCount) inserted, \(deletedCount) deleted)"
    }
}
