//
//  ItemDetailView.swift
//  BudgetApp
//
//  Created by Shumpei Horiuchi on 2024/09/08.
//

import SwiftData
import SwiftUI
import UIKit

struct ItemDetailView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) var colorScheme
    
    @State private var isShowAlert: Bool = false
    @State private var selectedIndex: Int? = nil
    
    @Query private var items: [BudgetsItem]

    private var thisItem: BudgetsItem
    private let maxWidth = UIScreen.main.bounds.width
    
    init(thisItem: BudgetsItem) {
        self.thisItem = thisItem
    }
    
    private let categoryImageNameArray: [String] = [
        Category.house.imageName,
        Category.foods.imageName,
        Category.clothes.imageName,
        Category.loan.imageName,
        Category.car.imageName,
        Category.hobbies.imageName,
        Category.debt.imageName,
        Category.cards.imageName,
        Category.other.imageName,
    ]
    
    private let categoryNameArray: [String] = [
        Category.house.categoryName,
        Category.foods.categoryName,
        Category.clothes.categoryName,
        Category.loan.categoryName,
        Category.car.categoryName,
        Category.hobbies.categoryName,
        Category.debt.categoryName,
        Category.cards.categoryName,
        Category.other.categoryName,
    ]
    
    private let sectionTitleList: [String] = [
        SectionTitle.title.label,
        SectionTitle.subTitle.label,
        SectionTitle.category.label,
        SectionTitle.price.label,
        SectionTitle.due.label
    ]
    
    private let categoryStatus: [String] = [
        ItemPurchaseStatus.couldNotBuyOnTime.displayText,
        ItemPurchaseStatus.inProgress.displayText,
        ItemPurchaseStatus.futurePurcahse.displayText,
        ItemPurchaseStatus.cancelled.displayText,
        ItemPurchaseStatus.isPurchased.displayText
    ]
    
    private let statusIconName: [String] = [
        SystemImageIconName.sunny.name,
        SystemImageIconName.cloudy.name,
        SystemImageIconName.rainy.name,
        SystemImageIconName.thunder.name,
        SystemImageIconName.cancel.name,
    ]
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea(.all)
            NavigationStack {
                baseScrollView
                    .navigationTitle(NavigationTitle.detail.name)
                    .navigationBarBackButtonHidden(true)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(action: {
                                dismiss()
                            }, label: {
                                HStack {
                                    Image(systemName: SystemImageIconName.back.name)
                                }
                                .contentShape(Rectangle())
                            })
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            HStack(spacing: Margin.smallSize){
                                NavigationLink(destination:
                                    ItemFormView(mode: .edit, thisItem: thisItem)
                                ) {
                                    Image(systemName: SystemImageIconName.edit.name)
                                }
                                .buttonStyle(PlainButtonStyle())
                                Spacer()
                                Button {
                                    isShowAlert = true
                                } label: {
                                    Image(systemName: SystemImageIconName.delete.name)
                                        .foregroundStyle(Color(.red))
                                }
                                .alert(AlertText.deleteItem.title, isPresented: $isShowAlert) {
                                    Button(AlertText.deleteItem.cancel, role: .cancel) {
                                        isShowAlert = false
                                    }
                                    Button(AlertText.deleteItem.desructive, role: .destructive) {
                                        if let item = items.first(where: {$0.uuid == thisItem.uuid}) {
                                            modelContext.delete(item)
                                            dismiss()
                                        }
                                    }
                                } message: {
                                    Text(AlertText.deleteItem.subTitle)
                                }
                            }
                            .padding(Margin.smallSize)
                        }
                    }
                    .toolbarBackground(.visible, for: .navigationBar)
                    .toolbarBackground(Color(.sectionBackground), for: .navigationBar)
                    .toolbarTitleDisplayMode(.inline)
            }
        }
    }
    
    var baseScrollView: some View {
        ScrollView {
            HStack {
                if let image = UIImage(data: thisItem.image) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: maxWidth, height: maxWidth / 4 * 3)
                        .clipShape(Rectangle())
                        
                } else {
                    ZStack(alignment: .center) {
                        Rectangle()
                            .fill(Color(.disabled))
                            .frame(width: maxWidth, height: maxWidth / 4 * 3)
                        Text("NO IMAGE")
                            .bold()
                            .foregroundStyle(colorScheme == .dark ? .white : .black)
                    }
                    
                }
            }
            VStack(alignment: .leading, spacing: Margin.defaultSize) {
                Spacer()
                HStack {
                    Text(thisItem.dueDate)
                        .foregroundStyle(.gray)
                        .fontWeight(.light)
                        .font(.subheadline)
                    Spacer()
                    Image(systemName: thisItem.iconName)
                    Text(thisItem.categoryName)
                }
                Text(thisItem.title)
                    .foregroundStyle(colorScheme == .dark ? .white : .black)
                    .fontWeight(.bold)
                    .font(.largeTitle)
                Text(thisItem.subTitle)
                    .foregroundStyle(.secondary)
                    .fontWeight(.regular)
                    .font(.caption)
                makePriceLabel(item: thisItem)
            }
            .padding(.horizontal, Margin.defaultSize)
            .padding(.bottom, Margin.bigSize)
            .frame(maxWidth: .infinity, alignment: .leading)
            ScrollView(.horizontal) {
                HStack {
                    ForEach(0 ..< categoryStatus.count, id: \.self) { index in
                        let size: CGFloat = 72.0
                        ZStack {
                            Circle()
                                .fill(selectedIndex == index ? Color.accentColor : Color(.disabled))
                                .frame(width: size, height: size)
                                .padding(.horizontal, Margin.defaultSize)
                            Image(systemName: statusIconName[index])
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.black)
                                .frame(width: size * 0.6, height: size * 0.6)
                        }
                        .onAppear() {
                            switch thisItem.status {
                            case categoryStatus[0]:
                                selectedIndex = 3
                            case categoryStatus[1]:
                                selectedIndex = 2
                            case categoryStatus[2]:
                                selectedIndex = 1
                            case categoryStatus[3]:
                                selectedIndex = 4
                            case categoryStatus[4]:
                                selectedIndex = 0
                            default:
                                break
                            }
                        }
                        .onTapGesture {
                            selectedIndex = index
                            var status = ""
                            switch selectedIndex {
                            case 0:
                                status = categoryStatus[4]
                                thisItem.itemfinishedDate = Date.convertToString(originalDate: Date())
                            case 1:
                                status = categoryStatus[2]
                            case 2:
                                status = categoryStatus[1]
                            case 3:
                                status = categoryStatus[0]
                            case 4:
                                status = categoryStatus[3]
                            default:
                                break
                            }
                            thisItem.updatedAt = Date()
                            thisItem.status = status
                            try? modelContext.save()
                        }
                        .tag(index)
                    }
                }
            }

        }
    }
    
    private func makePriceLabel(item: BudgetsItem) -> some View {
        var color = Color(.yellow)
        var changeColorFlag = false
        var statusText = ""
        var statusTextColor = Color(colorScheme == .dark ? .white : .black)
        switch item.status {
        case ItemPurchaseStatus.isPurchased.displayText:
            color = Color(.cyan)
            statusText = PaidStatus.purchased(item.itemfinishedDate).text
        case ItemPurchaseStatus.futurePurcahse.displayText:
            color = Color(.green)
            let remainDate = Date.calculateRemainDays(until: item.dueDate)
            statusText =  PaidStatus.remaining(abs(remainDate)).text
        case ItemPurchaseStatus.couldNotBuyOnTime.displayText:
            color = Color(.red)
            let remainDate = Date.calculateRemainDays(until: item.dueDate)
            statusText = PaidStatus.overdue(abs(remainDate)).text
            statusTextColor = Color(.red)
        case ItemPurchaseStatus.cancelled.displayText:
            changeColorFlag = true
            color = Color(Color(.disabled))
            statusText = PaidStatus.cancelled.text
            statusTextColor = Color(.lightGray)
        case ItemPurchaseStatus.inProgress.displayText:
            changeColorFlag = true
            let remainDate = Date.calculateRemainDays(until: item.dueDate)
            statusText =  PaidStatus.remaining(abs(remainDate)).text
        default:
            break
        }
        
        return VStack {
            HStack {
                Rectangle()
                    .fill(color)
                    .frame(height: 50)
                    .cornerRadius(8)
                    .overlay(content: {
                        Text(thisItem.price, format: .currency(code: "JPY"))
                            .foregroundStyle(changeColorFlag ? .black : .white)
                            .fontWeight(.bold)
                            .font(.title)
                    })
            }
            HStack {
                Text(statusText)
                    .foregroundStyle(statusTextColor)
            }
        }
    }
}
