//
//  MedicationListView.swift
//  MediDosis
//
//  Created by DEIMAR on 12/05/26.
//

import SwiftUI
import SwiftData

struct MedicationListView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Medication.name) private var medications: [Medication]

    @State private var showForm   = false
    @State private var editTarget: Medication? = nil
    @State private var searchText = ""

    var filtered: [Medication] {
        guard !searchText.isEmpty else { return medications }
        return medications.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        List {
            if filtered.isEmpty {
                ContentUnavailableView(
                    "Sin medicamentos",
                    systemImage: "pills",
                    description: Text("Toca + para agregar el primer fármaco")
                )
            } else {
                ForEach(filtered) { med in
                    MedicationRow(med: med)
                        .contentShape(Rectangle())
                        .onTapGesture { editTarget = med }
                }
                .onDelete(perform: delete)
            }
        }
        .searchable(text: $searchText, prompt: "Buscar fármaco")
        .navigationTitle("Catálogo")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button { showForm = true } label: {
                    Image(systemName: "plus")
                }
            }
            ToolbarItem(placement: .navigationBarLeading) {
                EditButton()
            }
        }
        .sheet(isPresented: $showForm) {
            MedicationFormView()
        }
        .sheet(item: $editTarget) { med in
            MedicationFormView(editing: med)
        }
    }

    private func delete(at offsets: IndexSet) {
        for i in offsets { context.delete(filtered[i]) }
    }
}

// ── Fila de medicamento ──
struct MedicationRow: View {
    let med: Medication

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(med.name).font(.headline)
                Spacer()
                PatientTypeBadge(type: med.patientType)
            }
            HStack(spacing: 12) {
                Label(String(format: "%.2f mg/kg", med.mgPerKg),
                      systemImage: "scalemass")
                Label(String(format: "Máx %.0f mg", med.maxDoseMg),
                      systemImage: "exclamationmark.shield")
                Label(med.route.rawValue,
                      systemImage: "arrow.right.circle")
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}

// ── Badge de tipo de paciente ──
struct PatientTypeBadge: View {
    let type: PatientType
    var body: some View {
        Text(type.rawValue)
            .font(.caption2).bold()
            .padding(.horizontal, 8).padding(.vertical, 3)
            .background(type == .pediatric ? Color.blue.opacity(0.15) : Color.green.opacity(0.15))
            .foregroundStyle(type == .pediatric ? .blue : .green)
            .clipShape(Capsule())
    }
}
