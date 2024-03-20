//
//  my_trafficApp.swift
//  my_traffic
//
//  Created by yhl on 2024/03/20.
//

import SwiftUI

@main
struct my_trafficApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
