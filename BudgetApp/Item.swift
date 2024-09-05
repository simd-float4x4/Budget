//
//  Item.swift
//  BudgetApp
//
//  Created by Shumpei Horiuchi on 2024/09/06.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
