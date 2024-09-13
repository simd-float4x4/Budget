//
//  ListSections.swift
//  BudgetApp
//
//  Created by Shumpei Horiuchi on 2024/09/13.
//

import Foundation

enum ListSections {
    case couldNotBuyOnTime
    case inProgress
    case futurePurchases
    case isPurchased
    case cancelled
    
    var title: String {
        switch self {
        case .inProgress:
            return "今月の購入予定"
        case .futurePurchases:
            return "今後の購入予定"
        case .isPurchased:
            return "過去分"
        case .couldNotBuyOnTime:
            return "予定超過"
        case .cancelled:
            return "キャンセル"
        }
    }
    
    var detail: String {
        switch self {
        case .inProgress:
            return generateInProgressDetailText()
        case .futurePurchases:
            return generateFuturePurchaseText()
        case .isPurchased:
            return "過去に登録されたデータを参照することが可能です。"
        case .couldNotBuyOnTime:
            return "期限を大幅に超過しています。ステータスの更新をお願いします。"
        case .cancelled:
            return "今月分のキャンセル一覧です。（先月以前は過去分を確認してください）"
        }
    }
    
    private func generateInProgressDetailText() -> String {
        let today = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: today)
        let month = calendar.component(.month, from: today)
        return "\(year)年\(month)月1日〜\(year)年\(month)月31日までの一ヶ月間に支払い予定のもののリストです。（自身で移動したものは除く）"
    }
    
    private func generateFuturePurchaseText() -> String {
        let today = Date()
        let calendar = Calendar.current
        var year = calendar.component(.year, from: today)
        var month = calendar.component(.month, from: today) + 1
        if year == 13 { year = 1 }
        if month == 13 { month = 1 }
        return "\(year)年\(month)月1日以降に支払い予定のもののリストです。（自身で移動したものは除く）"
    }
}
