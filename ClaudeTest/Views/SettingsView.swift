//
//  SettingsView.swift
//  ClaudeTest
//

import SwiftUI

struct SettingsView: View {
    @Binding var settings: PomodoroSettings
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section("Durations (minutes)") {
                    Stepper(
                        "Work: \(settings.workMinutes)",
                        value: $settings.workMinutes,
                        in: -10...120,
                        step: 5
                    )

                    Stepper(
                        "Short break: \(settings.shortBreakMinutes)",
                        value: $settings.shortBreakMinutes,
                        in: 0...30,
                        step: 1
                    )

                    Stepper(
                        "Long break: \(settings.longBreakMinutes)",
                        value: $settings.longBreakMinutes,
                        in: 0...60,
                        step: 5
                    )
                }

                Section("Cylce") {
                    Stepper(
                        "Sessions before long break: \(settings.sessionsBeforeLongBreak)",
                        value: $settings.sessionsBeforeLongBreak,
                        in: 1...10
                    )
                }

                Section {
                    Button("Reset to defaults", role: .destructive) {
                        settings = .defaults
                    }
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
