//
//  DosageResultView.swift
//  MediDosis
//
//  Created by Deimar on 12/05/26.
//
import SwiftUI
import SwiftData

struct DosageResultView: View {

    // Datos recibidos desde MedicationPickerView
    let patientName:   String
    let patientWeight: Double
    let patientAge:    Int
    let patientType:   PatientType
    let medication:    Medication

    // Contexto de SwiftData para guardar el registro
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss)      private var dismiss

    // ViewModel para el cálculo
    @State private var viewModel  = DosageViewModel()
    @State private var savedAlert = false
    @State private var alreadySaved = false

    // Resultado del cálculo
    var result: (dose: Double, capped: Bool) {
        viewModel.calculate(weightKg: patientWeight, medication: medication)
    }

    var body: some View {
        List {

            // ── Resumen del paciente ──
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

            // ── Resultado del cálculo ──
            Section("Dosis calculada") {
                VStack(spacing: 16) {

                    // Dosis en mg — número grande
                    Text(String(format: "%.1f mg", result.dose))
                        .font(.system(size: 52, weight: .bold, design: .rounded))
                        .foregroundStyle(result.capped ? .orange : .blue)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 8)

                    // Medicamento y vía
                    VStack(spacing: 4) {
                        Text(medication.name)
                            .font(.title3).bold()
                        Text("Vía \(medication.route.rawValue)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    // Detalle del cálculo
                    HStack(spacing: 20) {
                        VStack {
                            Text(String(format: "%.1f kg", patientWeight))
                                .font(.headline)
                            Text("Peso")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Text("×")
                            .foregroundStyle(.secondary)
                        VStack {
                            Text(String(format: "%.2f", medication.mgPerKg))
                                .font(.headline)
                            Text("mg/kg")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Text("=")
                            .foregroundStyle(.secondary)
                        VStack {
                            Text(String(format: "%.1f mg", result.dose))
                                .font(.headline)
                                .foregroundStyle(result.capped ? .orange : .blue)
                            Text("dosis")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.bottom, 8)
                }
            }

            // ── Alerta de tope máximo ──
            if result.capped {
                Section {
                    HStack(spacing: 12) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundStyle(.orange)
                            .font(.title2)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Dosis ajustada al máximo")
                                .font(.headline)
                                .foregroundStyle(.orange)
                            Text("La dosis calculada por peso superaba el máximo de \(String(format: "%.0f mg", medication.maxDoseMg)). Se aplicó el tope de seguridad.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }

            // ── Notas del medicamento ──
            if !medication.notes.isEmpty {
                Section("Indicaciones") {
                    Text(medication.notes)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }

            // ── Botón guardar ──
            Section {
                Button {
                    save()
                } label: {
                    HStack {
                        Spacer()
                        Label(
                            alreadySaved ? "Guardado" : "Guardar en historial",
                            systemImage: alreadySaved ? "checkmark.circle.fill" : "clock.badge.plus"
                        )
                        .bold()
                        .foregroundStyle(alreadySaved ? Color.secondary : Color.blue)
                        Spacer()
                    }
                }
                .disabled(alreadySaved)
            }
        }
        .navigationTitle("Resultado")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Guardado", isPresented: $savedAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("El cálculo fue guardado en el historial.")
        }
    }

    // ── Guardar en historial ──
    private func save() {
        let record = DosageRecord(
            patientName:   patientName,
            patientWeight: patientWeight,
            patientAge:    patientAge,
            patientType:   patientType,
            medication:    medication,
            calculatedMg:  result.dose
        )
        context.insert(record)
        alreadySaved = true
        savedAlert   = true
    }
}
