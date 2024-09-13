//
//  ItemPurchaseStatus.swift
//  BudgetApp
//
//  Created by Shumpei Horiuchi on 2024/09/13.
//

import Foundation

enum ItemPurchaseStatus {
    case couldNotBuyOnTime
    case inProgress // 今月
    case futurePurcahse // 来月以降
    case isPurchased
    case cancelled
    
    var displayText: String {
        switch self {
        case .inProgress:
            return "進行中"
        case .futurePurcahse:
            return "将来購入"
        case .isPurchased:
            return "購入済"
        case .couldNotBuyOnTime:
            return "予定超過"
        case .cancelled:
            return "キャンセル"
        }
    }
}
