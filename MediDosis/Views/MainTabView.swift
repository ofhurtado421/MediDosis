//
//  MainTabView.swift
//  MediDosis
//
//  Created by FABIAN on 12/05/26.
//
import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            NavigationStack { MedicationListView() }
                .tabItem { Label("Fármacos", systemImage: "pills.fill") }

            NavigationStack { Text("Próximamente") }
                .tabItem { Label("Dosificar", systemImage: "cross.fill") }

            NavigationStack { Text("Próximamente") }
                .tabItem { Label("Historial", systemImage: "clock.fill") }
        }
    }
}
