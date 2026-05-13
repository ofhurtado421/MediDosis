//
//  CreditsView.swift
//  MediDosis
//
//  Created by Deimar on 13/05/26.
//
import SwiftUI

struct CreditsView: View {
    var body: some View {
        List {

            // ── Logo y nombre ──
            Section {
                VStack(spacing: 12) {
                    Image(systemName: "cross.case.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(.blue)
                        .padding(.top, 8)

                    Text("MediDosis")
                        .font(.largeTitle).bold()

                    Text("Versión 1.0")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
            }

            // ── Descripción ──
            Section("Acerca de") {
                Text("MediDosis es una aplicación diseñada para calcular y dosificar medicamentos de forma segura según el peso y la edad del paciente. Permite gestionar un catálogo de fármacos con sus dosis por kilogramo y límites máximos de seguridad, dosificar pacientes pediátricos y adultos, y guardar un historial completo de cada cálculo realizado.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.vertical, 4)
            }

            // ── Integrantes ──
            Section("Desarrollado por") {
                MemberRow(
                    name: "Oscar Fabián Hurtado Hueje",
                    role: "Desarrollador iOS",
                    icon: "person.fill"
                )
                MemberRow(
                    name: "Deimar Quiñones",
                    role: "Desarrollador iOS",
                    icon: "person.fill"
                )
            }

            // ── Tecnologías ──
            Section("Construido con") {
                TechRow(name: "SwiftUI",    icon: "swift",              color: .orange)
                TechRow(name: "SwiftData",  icon: "cylinder.fill",      color: .blue)
                TechRow(name: "Xcode 15+",  icon: "hammer.fill",        color: .gray)
                TechRow(name: "iOS 17+",    icon: "iphone",             color: .green)
            }

            // ── Footer ──
            Section {
                Text("© 2024 MediDosis · Todos los derechos reservados")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
            }
        }
        .navigationTitle("Créditos")
    }
}

// ── Fila de integrante ──
struct MemberRow: View {
    let name: String
    let role: String
    let icon: String

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.blue)
                .frame(width: 36)

            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(.headline)
                Text(role)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

// ── Fila de tecnología ──
struct TechRow: View {
    let name:  String
    let icon:  String
    let color: Color

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)
                .frame(width: 36)

            Text(name)
                .font(.subheadline)
        }
        .padding(.vertical, 2)
    }
}
