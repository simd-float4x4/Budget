//
//  BudgetsListView.swift
//  BudgetApp
//
//  Created by Shumpei Horiuchi on 2024/09/06.
//

import SwiftUI
import SwiftData
import UIKit

struct BudgetsListView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) var colorScheme
    
    @Query private var items: [BudgetsItem]
   
    private var titleSections: [String] = [
        ListSections.couldNotBuyOnTime.title,
        ListSections.inProgress.title,
        ListSections.futurePurchases.title,
        ListSections.cancelled.title,
        ListSections.isPurchased.title
    ]
    
    private var detailSections: [String] = [
        ListSections.couldNotBuyOnTime.detail,
        ListSections.inProgress.detail,
        ListSections.futurePurchases.detail,
        ListSections.cancelled.detail,
        ListSections.isPurchased.detail
    ]
    
    private var dictionaryOrder: [String] = [
        ItemPurchaseStatus.couldNotBuyOnTime.displayText,
        ItemPurchaseStatus.inProgress.displayText,
        ItemPurchaseStatus.futurePurcahse.displayText,
        ItemPurchaseStatus.cancelled.displayText,
        ItemPurchaseStatus.isPurchased.displayText
    ]
    
    private var itemDictionaries: [String: [BudgetsItem]] {
        Dictionary(grouping: items, by: { $0.status })
    }
    
    private var totalPricesByStatus: [String: Int] {
        itemDictionaries.mapValues { items in
            items.reduce(0) { $0 + $1.price }
        }
    }
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea(.all)
            NavigationStack {
                baseScrollView
                    .navigationTitle(NavigationTitle.list.name)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination:
                            ItemFormView(mode: .add, thisItem:  BudgetsItem(
                                uuid: UUID(),
                                iconName: Category.house.imageName,
                                title: "",
                                subTitle: "",
                                price: 0,
                                categoryName: Category.house.categoryName,
                                dueDate: "",
                                image: Data(),
                                status: ItemPurchaseStatus.inProgress.displayText,
                                itemfinishedDate: "",
                                createdAt: Date(), updatedAt: Date()))
                        ){
                            Image(systemName: SystemImageIconName.add.name)
                        }
                    }
                }
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarBackground(Color(.sectionBackground), for: .navigationBar)
                .toolbarTitleDisplayMode(.inline)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    private var baseScrollView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ForEach(Array(itemDictionaries.keys.sorted {
                    dictionaryOrder.firstIndex(of: $0)! < dictionaryOrder.firstIndex(of: $1)!
                }), id: \.self) { section in
                    if let itemsInSection = itemDictionaries[section], !itemsInSection.isEmpty {
                       Group {
                           Text(titleSections[dictionaryOrder.firstIndex(of: section)!])
                               .foregroundStyle(colorScheme == .dark ? .white : .black)
                               .fontWeight(.bold)
                               .font(.largeTitle)
                           Text(detailSections[dictionaryOrder.firstIndex(of: section)!])
                               .foregroundStyle(.secondary)
                               .fontWeight(.regular)
                               .font(.caption)
                       }
                    }
                    ForEach(itemDictionaries[section] ?? []) { i in
                        VStack {
                            HStack {
                                Text(i.dueDate)
                                Spacer()
                            }
                            HStack {
                                baseIconView(i: i)
                                if let item = items.first(where: { $0.uuid == i.uuid }) {
                                    NavigationLink(destination: ItemDetailView(thisItem: item)) {
                                        HStack {
                                            baseContentCell(i: i)
                                            Spacer()
                                            basePriceCell(i: i)
                                        }
                                        .frame(maxWidth: .infinity)
                                        .contentShape(Rectangle())
                                    }
                                }
                            }
                        }
                        Divider()
                    }
                    Spacer()
                    totalSumPriceView(amount: totalPricesByStatus.first(where: { $0.key == section })?.value ?? 0)
                    Spacer()
                }
            }
            .padding(.top, Margin.defaultSize)
            .padding(.horizontal, Margin.defaultSize)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    private func baseIconView(i: BudgetsItem) -> some View {
        Menu {
            Button(ListSections.couldNotBuyOnTime.title, action: {
                onTapUpdateItemStatus(newValue: ItemPurchaseStatus.couldNotBuyOnTime.displayText, uuid: i.uuid)
            })
            Button(ListSections.inProgress.title, action: {
                onTapUpdateItemStatus(newValue: ItemPurchaseStatus.inProgress.displayText, uuid: i.uuid)
            })
            Button(ListSections.futurePurchases.title, action: {
                onTapUpdateItemStatus(newValue: ItemPurchaseStatus.futurePurcahse.displayText, uuid: i.uuid)
            })
            Button(ListSections.cancelled.title, action: {
                onTapUpdateItemStatus(newValue: ItemPurchaseStatus.cancelled.displayText, uuid: i.uuid)
            })
            Button(ListSections.isPurchased.title, action: {
                onTapUpdateItemStatus(newValue: ItemPurchaseStatus.isPurchased.displayText, uuid: i.uuid)
            })
        } label: {
            Image(systemName: i.iconName)
        }
    }
    
    private func baseContentCell(i: BudgetsItem) -> some View {
        let day = Date.calculateRemainDays(until: i.dueDate)
        return VStack(alignment: .leading) {
            Text(i.title)
                .fontWeight(.bold)
            Text(i.subTitle)
                .foregroundStyle(.gray)
            if i.itemfinishedDate == "" {
                Text(i.status == ItemPurchaseStatus.couldNotBuyOnTime.displayText
                     ? PaidStatus.overdue(abs(day)).text
                     : PaidStatus.remaining(abs(day)).text)
                    .foregroundStyle(.red)
                    .fontWeight(.semibold)
            }
        }
    }

    
    private func basePriceCell(i: BudgetsItem) -> some View {
        if i.status ==
            ItemPurchaseStatus.cancelled.displayText {
            Text("△\(i.price)")
                .foregroundColor(.gray)
                .fontWeight(.light)
        } else {
            Text("¥\(i.price)")
        }
    }
    
    private func totalSumPriceView(amount: Int) -> some View {
        HStack{
            Spacer()
            Text("合計金額　\(amount) 円")
                .foregroundStyle(colorScheme == .dark ? .white : .black)
                .fontWeight(.bold)
                .font(.title3)
        }
    }
    
    private func onTapUpdateItemStatus(newValue: String, uuid: UUID) {
            do {
                let index = items.firstIndex(where: { $0.uuid == uuid })
                guard let index else { return }
                items[index].updatedAt = Date()
                items[index].status = newValue
                if newValue == ItemPurchaseStatus.cancelled.displayText || newValue == ItemPurchaseStatus.isPurchased.displayText {
                    items[index].itemfinishedDate = Date.convertToString(originalDate: Date())
                } else {
                    items[index].itemfinishedDate = ""
                }
                try modelContext.save()
            } catch {
                print(error)
            }
    }
}

#Preview {
    BudgetsListView()
        .modelContainer(SampleData.previewContainer)
}
