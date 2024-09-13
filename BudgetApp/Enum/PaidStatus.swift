//
//  PaidStatus.swift
//  BudgetApp
//
//  Created by Shumpei Horiuchi on 2024/09/13.
//

import Foundation

enum PaidStatus {
    case overdue(Int)
    case remaining(Int)
    case cancelled
    case purchased(String)
    
    var text: String {
        switch self {
        case .overdue(let day):
            return "期限を\(day)日超過しています"
        case .remaining(let day):
            return "支払い期限まであと\(day)日"
        case .cancelled:
            return "この品物はキャンセルされました"
        case .purchased(let day):
            return "🎉 \(day)に購入済"
        }
    }
}
