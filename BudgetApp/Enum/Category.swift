//
//  Category.swift
//  BudgetApp
//
//  Created by Shumpei Horiuchi on 2024/09/13.
//

import Foundation

enum Category {
    case house
    case foods
    case clothes
    case loan
    case car
    case hobbies
    case debt
    case cards
    case other
    
    var categoryName: String {
        switch self {
        case .house:
            return "家"
        case .clothes:
            return "服"
        case .loan:
            return "ローン"
        case .foods:
            return "食品"
        case .car:
            return "車"
        case .hobbies:
            return "趣味"
        case .debt:
            return "借金"
        case .cards:
            return "カード"
        case .other:
            return "その他"
        }
    }
    
    var imageName: String {
        switch self {
        case .house:
            return "house"
        case .clothes:
            return "tshirt"
        case .loan:
            return "calendar"
        case .foods:
            return "fork.knife"
        case .car:
            return "car"
        case .hobbies:
            return "guitars"
        case .debt:
            return "dollarsign"
        case .cards:
            return "creditcard"
        case .other:
            return "ellipsis"
        }
    }
}
