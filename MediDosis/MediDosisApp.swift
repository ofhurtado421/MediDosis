//
//  MediDosisApp.swift
//  MediDosis
//
//  Created by FABIAN on 11/05/26.
//

import SwiftUI
import SwiftData

@main
struct MediDosisApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .modelContainer(for: [Medication.self, DosageRecord.self])
    }
}
