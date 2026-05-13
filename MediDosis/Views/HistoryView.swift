//
//  HistoryView.swift
//  MediDosis
//
//  Created by Deimar on 13/05/26.
//
import SwiftUI
import SwiftData

struct HistoryView: View {

    @Query(sort: \DosageRecord.date, order: .reverse) private var records: [DosageRecord]
    @Environment(\.modelContext) private var context

    @State private var searchText = ""

    var filtered: [DosageRecord] {
        guard !searchText.isEmpty else { return records }
        return records.filter {
            $0.patientName.localizedCaseInsensitiveContains(searchText) ||
            $0.medicationName.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        List {
            if filtered.isEmpty {
                ContentUnavailableView(
                    "Sin registros",
                    systemImage: "clock",
                    description: Text("Los cálculos guardados aparecerán aquí")
                )
            } else {
                ForEach(filtered) { record in
                    HistoryRow(record: record)
                }
                .onDelete(perform: delete)
            }
        }
        .searchable(text: $searchText, prompt: "Buscar paciente o medicamento")
        .navigationTitle("Historial")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                EditButton()
            }
        }
    }

    private func delete(at offsets: IndexSet) {
        for i in offsets { context.delete(filtered[i]) }
    }
}

// ── Fila del historial ──
struct HistoryRow: View {
    let record: DosageRecord

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "es_CO")
        return formatter.string(from: record.date)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {

            // ── Fila superior: nombre + badge ──
            HStack {
                Label(record.patientName, systemImage: "person.fill")
                    .font(.headline)
                Spacer()
                PatientTypeBadge(type: record.patientType)
            }

            // ── Medicamento y dosis ──
            HStack {
                Text(record.medicationName)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer()
                // Dosis en naranja si se aplicó tope
                Text(String(format: "%.1f mg", record.calculatedMg))
                    .font(.subheadline).bold()
                    .foregroundStyle(record.exceededMax ? .orange : .blue)
            }

            // ── Peso, edad y fecha ──
            HStack {
                Label(String(format: "%.1f kg", record.patientWeight),
                      systemImage: "scalemass")
                Text("·")
                Text("\(record.patientAge) años")
                Spacer()
                Text(formattedDate)
            }
            .font(.caption)
            .foregroundStyle(.secondary)

            // ── Indicador de tope aplicado ──
            if record.exceededMax {
                Label("Dosis ajustada al máximo permitido",
                      systemImage: "exclamationmark.triangle.fill")
                    .font(.caption)
                    .foregroundStyle(.orange)
            }
        }
        .padding(.vertical, 4)
    }
}
