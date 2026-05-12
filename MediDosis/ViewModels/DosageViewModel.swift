//
//  DosageViewModel.swift
//  MediDosis
//
//  Created by FABIAN on 12/05/26.
//

import Foundation
import SwiftUI

@Observable
class DosageViewModel {
    // Calcula la dosis y aplica el tope máximo
    func calculate(weightKg: Double,
                   medication: Medication) -> (dose: Double, capped: Bool) {
        let raw    = weightKg * medication.mgPerKg
        let capped = raw > medication.maxDoseMg
        let final  = min(raw, medication.maxDoseMg)
        return (final, capped)
    }
}
