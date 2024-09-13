//
//  Button.swift
//  BudgetApp
//
//  Created by Shumpei Horiuchi on 2024/09/13.
//

import Foundation

enum CustomButton {
    case add
    case edit
    
    var label: String {
        switch self {
        case .add:
            return "登録する"
        case .edit:
            return "更新する"
        }
    }
}
