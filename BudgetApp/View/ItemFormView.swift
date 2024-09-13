//
//  ItemFormView.swift
//  BudgetApp
//
//  Created by Shumpei Horiuchi on 2024/09/08.
//

import SwiftData
import SwiftUI
import UIKit

struct ItemFormView: View {
        
    private let mode: FormInputMode
    private let maxWidth = UIScreen.main.bounds.width
    private let grids = Array(repeating: GridItem(.flexible()), count: 2)
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [BudgetsItem]
    
    @State private var itemTitleText = ""
    @State private var itemSubTitleText = ""
    @State private var categoryName = ""
    @State private var categoryImageName = ""
    @State private var price = 0
    @State private var dueText = ""
    @State private var dueDate = Date()
    @State var isSelected: Int = 0
    @State var isShowingPicker = false
    @State var image: UIImage?
    @State var hasValidationError = false
    @State private var errorText = ""
  
    private var thisItem: BudgetsItem

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
    
    init(mode: FormInputMode, thisItem: BudgetsItem) {
        self.mode = mode
        self.thisItem = thisItem
        
        _itemTitleText = State(initialValue: thisItem.title)
        _itemSubTitleText = State(initialValue: thisItem.subTitle)
        _categoryName = State(initialValue: thisItem.categoryName)
        _categoryImageName = State(initialValue: thisItem.iconName)
        _price = State(initialValue: thisItem.price)
        _dueText = State(initialValue: thisItem.dueDate)
        
        if let findIndex = categoryNameArray.firstIndex(where: {$0 == categoryName}) {
            let index: Int = findIndex
            _isSelected = State(initialValue: index)
        } else {
            _isSelected = State(initialValue: 0)
        }
    }
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea(.all)
            NavigationStack {
                baseScrollView
                    .navigationTitle(mode == .add ? NavigationTitle.add.name : NavigationTitle.edit.name)
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
                    }
                    .toolbarBackground(.visible, for: .navigationBar)
                    .toolbarBackground(Color(.sectionBackground), for: .navigationBar)
                    .toolbarTitleDisplayMode(.inline)
                    .onTapGesture {
                        UIApplication.shared.endEditing()
                    }
            }
        }
    }
    
    private var baseScrollView: some View {
        ScrollView {
            ZStack(alignment: .bottomLeading) {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: maxWidth, height: maxWidth / 4 * 3)
                        .clipShape(Rectangle())
                } else if let image = UIImage(data: thisItem.image)  {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: maxWidth, height: maxWidth / 4 * 3)
                        .clipShape(Rectangle())
                } else {
                    Rectangle()
                        .fill(Color(.disabled))
                        .frame(width: maxWidth, height: maxWidth / 4 * 3)
                }
                makeSelectImageButton()
            }
            VStack(alignment: .leading, spacing: Margin.defaultSize) {
                ForEach(Array(sectionTitleList.enumerated()), id: \.element) { index, label in
                    VStack {
                        makeLabelStack(content: label, style: colorScheme == .dark ? .white : .black, weight: .bold, font: .title)
                        switch index {
                        case 0:
                            makeInputTitleField()
                        case 1:
                            makeInputSubTitleField()
                        case 2:
                            makeCategoryList(i: index)
                        case 3:
                            makePriceLabel()
                        case 4:
                            makeCalendar()
                        default:
                            Spacer()
                        }
                    }
                }
                if hasValidationError == true {
                   makeValidationArea()
                }
                HStack {
                    Button(action: {
                        registeringData()
                    }) {
                        makeFinishButton()
                   }
                   .padding()
                }
            }
            .padding(Margin.defaultSize)
        }
    }
    
    private func makeSelectImageButton() -> some View {
        Button {
            isShowingPicker.toggle()
        } label: {
            let size: CGFloat = 72.0
            ZStack {
                Circle()
                    .fill(Color.accentColor)
                    .frame(width: size, height: size)
                    .padding(Margin.defaultSize)
                Image(systemName: SystemImageIconName.media.name)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.black)
                    .frame(width: size * 0.6, height: size * 0.6)
            }
        }
        .sheet(isPresented: $isShowingPicker) {
            ImagePickerView(image: $image, sourceType: .library)
        }
    }

    private func makeInputTitleField() -> some View {
        VStack {
            TextEditor(text: $itemTitleText)
                .scrollContentBackground(.hidden)
                .frame(height: 44)
                .background(Color(.contentBackground))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 0.6)
                )
                .padding(.vertical, 10)
                .contentShape(Rectangle())
                .onTapGesture {
                    UIApplication.shared.endEditing()
                }
        }
        .frame(maxHeight: .infinity, alignment: .center)
        .overlay(alignment: .topLeading) {
            if itemTitleText.isEmpty {
                Text("タイトルを入力")
                    .foregroundStyle(Color.gray)
                    .padding(Margin.mediumSize)
            }
        }
    }
    
    private func makeInputSubTitleField() -> some View {
        TextEditor(text: $itemSubTitleText)
            .scrollContentBackground(.hidden)
            .frame(height: 200)
            .background(Color(.contentBackground))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
            .stroke(Color.gray, lineWidth: 0.6))
            .overlay(alignment: .topLeading) {
                if itemSubTitleText.count == 0 {
                    Text("詳細情報を入力")
                        .foregroundStyle(Color.gray)
                        .padding(Margin.mediumSize)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
    }
    
    private func makePriceLabel() -> some View {
        TextField("", value: $price, format: .number)
            .scrollContentBackground(.hidden)
            .textFieldStyle(.roundedBorder)
            .background(Color(.contentBackground))
            .keyboardType(.decimalPad)
            .multilineTextAlignment(TextAlignment.trailing)
            .contentShape(Rectangle())
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
    }
    
    private func makeCalendar() -> some View {
        DatePicker(
            "開始日を選択",
            selection: $dueDate,
            displayedComponents: [.date]
        )
        .datePickerStyle(.graphical)
        .contentShape(Rectangle())
        // iOS17.1 TexitFieldのバグ対策
        .onTapGesture (count: 99, perform: {})
    }
    
    private func makeValidationArea() -> some View {
        HStack {
            Image(systemName: SystemImageIconName.warning.name)
                .padding(.horizontal, Margin.smallSize)
            Text(errorText)
            Spacer()
        }
        .frame(height: 44)
        .foregroundColor(.red)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(.red, lineWidth: 2)
        )
        .padding(.horizontal, Margin.defaultSize)
    }
    
    private func makeFinishButton() -> some View {
        Text(mode == .add ? CustomButton.add.label : CustomButton.edit.label)
           .frame(maxWidth: .infinity)
           .padding()
           .background(Color.accentColor)
           .foregroundColor(.black)
           .cornerRadius(8)
    }
    
    private func registeringData() {
        var thisErrorText = ""
        var errorMessageArray: [String:String] = [
            "titleIsRequired" : "タイトルは必須です。"
        ]

        if itemTitleText != "" {
            hasValidationError = false
            thisItem.title = itemTitleText
            errorMessageArray.removeValue(forKey: "titleIsRequired")
        } else {
            hasValidationError = true
            if let errorString = errorMessageArray["titleIsRequired"] {
                if thisErrorText != "" { thisErrorText += "\n" }
                thisErrorText += "\(errorString)"
            }
        }
        
        thisItem.subTitle = itemSubTitleText
        thisItem.categoryName = categoryName
        thisItem.iconName = categoryImageName
        thisItem.price = price
        thisItem.createdAt = Date()
        thisItem.updatedAt = Date()
        
        if Date.isPast(day: dueDate) {
            thisItem.status = ItemPurchaseStatus.couldNotBuyOnTime.displayText
        } else {
            if Date.isNextMonth(day: dueDate) {
                thisItem.status = ItemPurchaseStatus.futurePurcahse.displayText
            } else {
                thisItem.status = ItemPurchaseStatus.inProgress.displayText
            }
        }
        
        thisItem.dueDate = Date.convertToString(originalDate: dueDate)
        
        if let savingImage = image {
            thisItem.image = savingImage.pngData() ?? Data()
        }
        
        if hasValidationError == false {
            switch mode {
            case .add:
                modelContext.insert(thisItem)
                dismiss()
            case .edit:
                thisItem.updatedAt = Date()
                try? modelContext.save()
                dismiss()
            }
        } else {
            errorText = thisErrorText
        }
    }
    
    private func makeLabelStack(content: String, style: any ShapeStyle, weight: Font.Weight, font: Font) -> some View {
        HStack {
            modifierText(content: content, style: style, weight: weight, font: font)
            Spacer()
        }
    }
    
    private func modifierText(content: String, style: any ShapeStyle, weight: Font.Weight, font: Font) -> some View {
        return Text(content)
            .foregroundStyle(style)
            .fontWeight(weight)
            .font(font)
    }
    
    private func makeCategoryList(i: Int) -> some View {
        return LazyVGrid(columns: grids) {
            ForEach(Array(categoryNameArray.enumerated()), id: \.element) { i, item in
                let backgroundColor = i == isSelected ? .accentColor : Color(.disabled)
                HStack {
                    Image(systemName: categoryImageNameArray[i])
                    Text("\(item)")
                }
                .padding(Margin.smallSize)
                .frame(width: maxWidth/2 - Margin.defaultSize, height: 60)
                .background(backgroundColor)
                .foregroundColor(.black)
                .cornerRadius(8)
                .onTapGesture {
                    isSelected = i
                    categoryName = item
                    categoryImageName = categoryImageNameArray[i]
                }
            }
        }
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
