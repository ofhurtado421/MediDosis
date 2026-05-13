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

            NavigationStack { PatientFormView()}
                .tabItem { Label("Dosificar", systemImage: "cross.fill") }

            NavigationStack { HistoryView() }
                .tabItem { Label("Historial", systemImage: "clock.fill") }
            
            NavigationStack { CreditsView() }
                .tabItem { Label("Créditos", systemImage: "info.circle.fill") }
        }
    }
}
