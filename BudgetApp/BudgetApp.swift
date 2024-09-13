//
//  BudgetApp.swift
//  BudgetApp
//
//  Created by Shumpei Horiuchi on 2024/09/06.
//

import SwiftUI
import SwiftData

@main
struct BudgetApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            BudgetsItem.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error.localizedDescription)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            BudgetsListView()
        }
        .modelContainer(sharedModelContainer)
    }
}
