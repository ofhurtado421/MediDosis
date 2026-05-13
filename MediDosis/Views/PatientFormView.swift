//
//  PatientFormView.swift
//  MediDosis
//
//  Created by FABIAN on 12/05/26.
//
import SwiftUI

struct PatientFormView: View {

    @State private var name        = ""
    @State private var weight      = ""
    @State private var age         = ""
    @State private var patientType = PatientType.pediatric

    var isValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
        && Double(weight) != nil
        && Int(age) != nil
    }

    var body: some View {
        Form {
            // ── Datos del paciente ──
            Section("Datos del paciente") {
                TextField("Nombre del paciente", text: $name)
                    .textInputAutocapitalization(.words)

                Picker("Tipo de paciente", selection: $patientType) {
                    ForEach(PatientType.allCases, id: \.self) {
                        Text($0.rawValue).tag($0)
                    }
                }
                .pickerStyle(.segmented)
            }

            // ── Medidas ──
            Section("Medidas") {
                HStack {
                    Text("Peso")
                    Spacer()
                    TextField("0.0", text: $weight)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 80)
                    Text("kg")
                        .foregroundStyle(.secondary)
                }

                HStack {
                    Text("Edad")
                    Spacer()
                    TextField("0", text: $age)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 80)
                    Text("años")
                        .foregroundStyle(.secondary)
                }
            }

            // ── Botón continuar ──
            Section {
                NavigationLink {
                    MedicationPickerView(
                        patientName:    name,
                        patientWeight:  Double(weight) ?? 0,
                        patientAge:     Int(age) ?? 0,
                        patientType:    patientType
                    )
                } label: {
                    HStack {
                        Spacer()
                        Text("Seleccionar medicamento")
                            .bold()
                            .foregroundStyle(isValid ? .blue : .secondary)
                        Spacer()
                    }
                }
                .disabled(!isValid)
            }
        }
        .navigationTitle("Nuevo cálculo")
    }
}
