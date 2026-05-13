//
//  MedicationPickerView.swift
//  MediDosis
//
//  Created by FABIAN on 12/05/26.
//
import SwiftUI
import SwiftData

struct MedicationPickerView: View {

    // Datos recibidos desde PatientFormView
    let patientName:   String
    let patientWeight: Double
    let patientAge:    Int
    let patientType:   PatientType

    // Trae todos los medicamentos de la base de datos
    @Query(sort: \Medication.name) private var medications: [Medication]

    @State private var searchText = ""

    // Filtra por tipo de paciente Y por texto de búsqueda
    var filtered: [Medication] {
        medications.filter { med in
            let matchesType = med.patientType == patientType
            let matchesSearch = searchText.isEmpty ||
                med.name.localizedCaseInsensitiveContains(searchText)
            return matchesType && matchesSearch
        }
    }

    var body: some View {
        List {
            // Encabezado con datos del paciente
            Section("Paciente") {
                HStack {
                    Label(patientName, systemImage: "person.fill")
                    Spacer()
                    PatientTypeBadge(type: patientType)
                }
                HStack {
                    Label(String(format: "%.1f kg", patientWeight),
                          systemImage: "scalemass.fill")
                    Spacer()
                    Label("\(patientAge) años",
                          systemImage: "calendar")
                        .foregroundStyle(.secondary)
                }
                .font(.subheadline)
            }

            // Lista de medicamentos filtrados
            Section("Medicamentos disponibles") {
                if filtered.isEmpty {
                    ContentUnavailableView(
                        "Sin resultados",
                        systemImage: "pills",
                        description: Text("No hay medicamentos para este tipo de paciente")
                    )
                } else {
                    ForEach(filtered) { med in
                        NavigationLink {
                            DosageResultView(
                                patientName:   patientName,
                                patientWeight: patientWeight,
                                patientAge:    patientAge,
                                patientType:   patientType,
                                medication:    med
                            )
                        } label: {
                            MedicationPickerRow(med: med)
                        }
                    }
                }
            }
        }
        .searchable(text: $searchText, prompt: "Buscar medicamento")
        .navigationTitle("Seleccionar medicamento")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// ── Fila del picker ──
struct MedicationPickerRow: View {
    let med: Medication

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(med.name)
                .font(.headline)

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
