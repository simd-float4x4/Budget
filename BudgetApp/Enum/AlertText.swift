//
//  AlertText.swift
//  BudgetApp
//
//  Created by Shumpei Horiuchi on 2024/09/13.
//

import Foundation

enum AlertText {
    case deleteItem
    
    var title: String {
        switch self {
        case .deleteItem:
            return "削除しますか？"
        }
    }
    
    var subTitle: String {
        switch self {
        case .deleteItem:
            return "削除されたアイテムは復元できません。"
        }
    }
    
    var desructive: String {
        switch self {
        case .deleteItem:
            return "削除する"
        }
    }
    
    var cancel: String {
        switch self {
        case .deleteItem:
            return "キャンセル"
        }
    }
}
