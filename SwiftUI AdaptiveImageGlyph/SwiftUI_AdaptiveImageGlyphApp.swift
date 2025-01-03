//
//  SwiftUI_AdaptiveImageGlyphApp.swift
//  SwiftUI AdaptiveImageGlyph
//
//  Created by Aether on 03/01/2025.
//

import SwiftUI

@main
struct SwiftUI_AdaptiveImageGlyphApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
