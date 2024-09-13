//
//  NavigationTitle.swift
//  BudgetApp
//
//  Created by Shumpei Horiuchi on 2024/09/13.
//

import Foundation

enum NavigationTitle {
    case list
    case add
    case edit
    case detail
    
    var name: String {
        switch self {
        case .list:
            return "ホーム"
        case .add:
            return "登録"
        case .edit:
            return "編集"
        case .detail:
            return "詳細"
        }
    }
}
