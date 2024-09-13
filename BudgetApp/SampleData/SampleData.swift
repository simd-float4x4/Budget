//
//  SampleData.swift
//  BudgetApp
//
//  Created by Shumpei Horiuchi on 2024/09/08.
//

import Foundation
import SwiftData
import UIKit


@MainActor
class SampleData {
    static let previewContainer: ModelContainer = {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(
                for: BudgetsItem.self,
                configurations: config
            )
            
            let today = Date()
            let todayString = Date.convertToString(originalDate: today)
            let oneMonthAgo = Date.convertToString(originalDate: Calendar.current.date(byAdding: .month, value: -1, to: today) ?? Date())
            let oneMonthFuture = Date.convertToString(originalDate: Calendar.current.date(byAdding: .month, value: 1, to: today) ?? Date())

            let sampleBudgets: [BudgetsItem] = [
                // 進行中
                BudgetsItem(
                    uuid: UUID(),
                    iconName: Category.car.imageName,
                    title: "車検代を支払う（進行中0）",
                    subTitle: "自宅に届いた封書で支払う　コンビニ可",
                    price: 30000,
                    categoryName: Category.car.categoryName,
                    dueDate: oneMonthFuture,
                    image: Data(),
                    status: ItemPurchaseStatus.inProgress.displayText,
                    itemfinishedDate: "",
                    createdAt: Date(),
                    updatedAt: Date()
                ),
                
                BudgetsItem(
                    uuid: UUID(),
                    iconName: Category.foods.imageName,
                    title: "セブンイレブンの新商品🍩（進行中1）",
                    subTitle: "メープル・カスタード・チョコの3種類",
                    price: 190,
                    categoryName: Category.foods.categoryName,
                    dueDate: oneMonthFuture,
                    image: Data(),
                    status: ItemPurchaseStatus.inProgress.displayText,
                    itemfinishedDate: "",
                    createdAt: Date(),
                    updatedAt: Date()
                ),
                
                // 購入済
                BudgetsItem(
                    uuid: UUID(),
                    iconName: Category.foods.imageName,
                    title: "IKEAの新商品・ドーナツを食べる（購入済2）",
                    subTitle: "青色と桃色があるらしい",
                    price: 290,
                    categoryName: Category.foods.categoryName,
                    dueDate: todayString,
                    image: Data(),
                    status: ItemPurchaseStatus.isPurchased.displayText,
                    itemfinishedDate: todayString,
                    createdAt: Date(),
                    updatedAt: Date()
                ),
                
                // 予定超過
                BudgetsItem(
                    uuid: UUID(),
                    iconName: Category.cards.imageName,
                    title: "VISA（予定超過3）",
                    subTitle: "先月分のクレジットカード代金",
                    price: 37800,
                    categoryName: Category.cards.categoryName,
                    dueDate: oneMonthAgo,
                    image: Data(),
                    status: ItemPurchaseStatus.couldNotBuyOnTime.displayText,
                    itemfinishedDate: "",
                    createdAt: Date(),
                    updatedAt: Date()
                ),
                
                // キャンセル
                BudgetsItem(
                    uuid: UUID(),
                    iconName: Category.hobbies.imageName,
                    title: "逆転検事1・2　御剣コレクション（キャンセル4）",
                    subTitle: "NintendoSwitch　パッケージ版",
                    price: 6800,
                    categoryName: Category.hobbies.categoryName,
                    dueDate: todayString,
                    image: Data(),
                    status: ItemPurchaseStatus.cancelled.displayText,
                    itemfinishedDate: todayString,
                    createdAt: Date(),
                    updatedAt: Date()
                ),
                
                // 将来
                BudgetsItem(
                    uuid: UUID(),
                    iconName: Category.house.imageName,
                    title: "退去費用（将来5）",
                    subTitle: "退去予定日の一ヶ月前に申告が必要",
                    price: 48500,
                    categoryName: Category.house.categoryName,
                    dueDate: oneMonthFuture,
                    image: Data(),
                    status: ItemPurchaseStatus.futurePurcahse.displayText,
                    itemfinishedDate: oneMonthFuture,
                    createdAt: Date(),
                    updatedAt: Date()
                ),
            ]

            for i in sampleBudgets {
                container.mainContext.insert(i)
            }

            return container
        } catch {
            fatalError("Failed to create model container for previewing: \(error.localizedDescription)")
        }
    }()
}
