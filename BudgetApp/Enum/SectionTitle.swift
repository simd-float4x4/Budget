//
//  SectionTitle.swift
//  BudgetApp
//
//  Created by Shumpei Horiuchi on 2024/09/12.
//

import Foundation

enum SectionTitle {
    case title
    case subTitle
    case category
    case price
    case due
    
    var label: String {
        switch self {
        case .title:
            return "タイトル"
        case .subTitle:
            return "サブタイトル"
        case .category:
            return "カテゴリ"
        case .price:
            return "価格"
        case .due:
            return "期日"
        }
    }
}
