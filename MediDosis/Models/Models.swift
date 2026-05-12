//
//  Models.swift
//  MediDosis
//
//  Created by FABIAN on 12/05/26.
//
import SwiftData
import Foundation

// Tipos de paciente
enum PatientType: String, Codable, CaseIterable {
    case pediatric = "Pediátrico"
    case adult     = "Adulto"
}

// Vías de administración
enum Route: String, Codable, CaseIterable {
    case oral = "Oral"
    case iv   = "IV"
    case im   = "IM"
    case topical = "Tópica"
}

// ── Medicamento (catálogo editable) ──
@Model
class Medication {
    var name:        String
    var mgPerKg:     Double   // dosis por kg
    var maxDoseMg:   Double   // dosis máxima absoluta
    var route:       Route
    var patientType: PatientType  // pediátrico, adulto o ambos
    var notes:       String

    init(name: String, mgPerKg: Double, maxDoseMg: Double,
         route: Route, patientType: PatientType, notes: String = "") {
        self.name        = name
        self.mgPerKg     = mgPerKg
        self.maxDoseMg   = maxDoseMg
        self.route       = route
        self.patientType = patientType
        self.notes       = notes
    }
}

// ── Registro de dosis calculada (historial) ──
@Model
class DosageRecord {
    var date:           Date
    var patientName:    String
    var patientWeight:  Double
    var patientAge:     Int
    var patientType:    PatientType
    var medicationName: String
    var calculatedMg:   Double
    var maxDoseMg:      Double
    var route:          Route

    // ¿superó la dosis máxima? (seguridad)
    var exceededMax: Bool { calculatedMg > maxDoseMg }

    init(patientName: String, patientWeight: Double, patientAge: Int,
         patientType: PatientType, medication: Medication, calculatedMg: Double) {
        self.date           = .now
        self.patientName    = patientName
        self.patientWeight  = patientWeight
        self.patientAge     = patientAge
        self.patientType    = patientType
        self.medicationName = medication.name
        self.calculatedMg   = calculatedMg
        self.maxDoseMg      = medication.maxDoseMg
        self.route          = medication.route
    }
}
