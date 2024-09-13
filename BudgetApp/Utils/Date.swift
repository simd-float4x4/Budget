//
//  Date.swift
//  BudgetApp
//
//  Created by Shumpei Horiuchi on 2024/09/11.
//

import SwiftUI
import UIKit

extension Date {
    // DateをStringに変換して渡します
    static func convertToString(originalDate: Date) -> String {
        let formatter: DateFormatter = DateFormatter()
        let locale = Locale(identifier: "ja_JP")
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = "yyyy年MM月dd日"
        formatter.locale = locale
        return formatter.string(from: originalDate)
    }
    
    // StringをDateに変換して渡します
    static func convertToDate(originalString: String) -> Date {
        let formatter: DateFormatter = DateFormatter()
        let locale = Locale(identifier: "ja_JP")
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = "yyyy年MM月dd日"
        formatter.locale = locale
        return formatter.date(from: originalString) ?? Date()
    }
    
    // 支払日までの残日数を計算します
    static func calculateRemainDays(until: String) -> Int {
        let today = Date()
        let dueDate = Date.convertToDate(originalString: until)
        let remain = Calendar.current.dateComponents([.day], from: today, to: dueDate)
        //　今日の0:00-23:59と締切日の-23:59を含めたいため2日追加（計算できなかった場合は0になるように-2に設定）
        let dayDifference = Int(remain.day ?? -2) + 2
        return dayDifference
    }
    
    // 渡されたdayが今日より過去の日付か判定します
    static func isPast(day: Date) -> Bool {
        let now = Date()
        return day < now
    }
     
    // 渡されたdayが今月か来月か判定します
    static func isNextMonth(day: Date) -> Bool {
        let calendar = Calendar.current
        let today = Date()
        let currentYear = calendar.component(.year, from: today)
        let currentMonth = calendar.component(.month, from: today)
        let targetYear = calendar.component(.year, from: day)
        let targetMonth = calendar.component(.month, from: day)
        
        return targetYear == currentYear && targetMonth == currentMonth + 1
    }
}
