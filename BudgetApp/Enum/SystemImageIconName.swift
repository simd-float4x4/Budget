//
//  SystemImageIconName.swift
//  BudgetApp
//
//  Created by Shumpei Horiuchi on 2024/09/13.
//

import Foundation

enum SystemImageIconName {
    case add
    case edit
    case delete
    case warning
    case back
    case sunny
    case cloudy
    case rainy
    case thunder
    case cancel
    case media
    
    var name: String {
        switch self {
        case .add:
            return "plus"
        case .edit:
            return "square.and.pencil"
        case .delete:
            return "trash.fill"
        case .warning:
            return "exclamationmark.triangle.fill"
        case .back:
            return "chevron.left"
        case .sunny:
            return "sun.max"
        case .cloudy:
            return "cloud"
        case .rainy:
            return "cloud.rain"
        case .thunder:
            return "bolt.fill"
        case .cancel:
            return "multiply"
        case .media:
            return "photo"
        }
    }
}
