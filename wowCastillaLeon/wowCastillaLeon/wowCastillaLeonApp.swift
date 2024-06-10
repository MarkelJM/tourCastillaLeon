//
//  wowCastillaLeonApp.swift
//  wowCastillaLeon
//
//  Created by Markel Juaristi on 10/6/24.
//

import SwiftUI

@main
struct wowCastillaLeonApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
