//
//  BudgetsItem.swift
//  BudgetApp
//
//  Created by Shumpei Horiuchi on 2024/09/06.
//

import Foundation
import SwiftData
import UIKit

@Model
final class BudgetsItem {
    init(uuid: UUID, iconName: String, title: String, subTitle: String, price: Int, categoryName: String, dueDate: String, image: Data, status: String, itemfinishedDate: String, createdAt: Date, updatedAt: Date) {
        self.uuid = uuid
        self.iconName = iconName
        self.title = title
        self.subTitle = subTitle
        self.price = price
        self.categoryName = categoryName
        self.dueDate = dueDate
        self.image = image
        self.status = status
        self.itemfinishedDate = itemfinishedDate
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    var uuid: UUID
    var iconName: String
    var title: String
    var subTitle: String
    var price: Int
    var categoryName: String
    var dueDate: String
    var image: Data
    var status: String
    var itemfinishedDate: String
    var createdAt: Date
    var updatedAt: Date
}
