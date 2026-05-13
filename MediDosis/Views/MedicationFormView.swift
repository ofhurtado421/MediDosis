//
//  Untitled.swift
//  MediDosis
//
//  Created by DEIMAR on 12/05/26.
//
import SwiftUI
import SwiftData

struct MedicationFormView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss)      private var dismiss

    // Si viene con un medicamento = modo edición
    var editing: Medication? = nil

    @State private var name        = ""
    @State private var mgPerKg     = ""
    @State private var maxDoseMg   = ""
    @State private var route       = Route.oral
    @State private var patientType = PatientType.pediatric
    @State private var notes       = ""
    @State private var showAlert   = false

    var isValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
        && Double(mgPerKg) != nil
        && Double(maxDoseMg) != nil
    }

    var body: some View {
        NavigationStack {
            Form {
                // ── Datos básicos ──
                Section("Identificación") {
                    TextField("Nombre del fármaco", text: $name)
                        .textInputAutocapitalization(.words)

                    Picker("Tipo de paciente", selection: $patientType) {
                        ForEach(PatientType.allCases, id: \.self) {
                            Text($0.rawValue).tag($0)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                // ── Dosificación ──
                Section("Dosificación") {
                    HStack {
                        Text("Dosis")
                        Spacer()
                        TextField("0.00", text: $mgPerKg)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                        Text("mg / kg")
                            .foregroundStyle(.secondary)
                    }

                    HStack {
                        Text("Dosis máxima")
                        Spacer()
                        TextField("0", text: $maxDoseMg)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                        Text("mg")
                            .foregroundStyle(.secondary)
                    }
                }

                // ── Vía de administración ──
                Section("Vía de administración") {
                    Picker("Vía", selection: $route) {
                        ForEach(Route.allCases, id: \.self) {
                            Text($0.rawValue).tag($0)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                // ── Notas ──
                Section("Notas / Indicaciones") {
                    TextField("Ej: administrar con alimentos...",
                              text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle(editing == nil ? "Nuevo fármaco" : "Editar fármaco")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") { save() }
                        .disabled(!isValid)
                        .bold()
                }
            }
            .alert("Campos incompletos", isPresented: $showAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Revisa que el nombre y las dosis sean válidos.")
            }
            .onAppear { loadIfEditing() }
        }
    }

    // ── Lógica ──
    private func loadIfEditing() {
        guard let med = editing else { return }
        name        = med.name
        mgPerKg     = String(med.mgPerKg)
        maxDoseMg   = String(med.maxDoseMg)
        route       = med.route
        patientType = med.patientType
        notes       = med.notes
    }

    private func save() {
        guard isValid,
              let mg   = Double(mgPerKg),
              let maxD = Double(maxDoseMg) else {
            showAlert = true
            return
        }

        if let med = editing {
            // Modo edición — actualiza
            med.name        = name
            med.mgPerKg     = mg
            med.maxDoseMg   = maxD
            med.route       = route
            med.patientType = patientType
            med.notes       = notes
        } else {
            // Modo creación — inserta
            let nuevo = Medication(
                name: name, mgPerKg: mg, maxDoseMg: maxD,
                route: route, patientType: patientType, notes: notes
            )
            context.insert(nuevo)
        }
        dismiss()
    }
}

