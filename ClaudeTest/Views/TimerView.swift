//
//  TimerView.swift
//  ClaudeTest
//

import SwiftUI

struct TimerView: View {
    @StateObject private var history = SessionHistoryStore()
    @State private var settings: PomodoroSettings = .defaults
    @StateObject private var timer: PomodoroTimer

    @State private var showingSettings = false
    @State private var showingHistory = false
    @State private var lastInteractionAt: Date = Date()

    init() {
        let h = SessionHistoryStore()
        _history = StateObject(wrappedValue: h)
        _timer = StateObject(wrappedValue: PomodoroTimer(settings: .defaults, history: h))
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                Spacer()

                Text(formattedTime)
                    .font(.system(size: 96, weight: .thin, design: .rounded))
                    .monospacedDigit()
                    .foregroundStyle(Color(red: 0.2, green: 0.6, blue: 0.9))

                phaseLabel

                controls

                Spacer()
            }
            .padding()
            .navigationTitle("Pomodoro")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingHistory = true
                    } label: {
                        Image(systemName: "clock.arrow.circlepath")
                    }
                }
                ToolbarItem(placement: .navigation) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView(settings: $settings)
                    .onDisappear { timer.updateSettings(settings) }
            }
            .sheet(isPresented: $showingHistory) {
                HistoryView()
                    .environmentObject(history)
            }
        }
    }

    private var formattedTime: String {
        let total = timer.remainingSeconds
        let minutes = total / 60
        let seconds = total % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    @ViewBuilder
    private var phaseLabel: some View {
        switch timer.phase {
        case .idle:
            Text("Ready")
                .font(.title3)
                .foregroundStyle(.secondary)
        case .running(let kind, _):
            Text(label(for: kind) + " in progress")
                .font(.title3)
                .foregroundStyle(.secondary)
        case .paused(let kind, _):
            Text(label(for: kind) + " paused")
                .font(.title3)
                .foregroundStyle(.secondary)
        }
    }

    @ViewBuilder
    private var controls: some View {
        HStack(spacing: 24) {
            switch timer.phase {
            case .idle:
                Button("Start Work") { timer.start(kind: .work) }
                    .buttonStyle(.borderedProminent)
                Button("Short Break") { timer.start(kind: .shortBreak) }
                Button("Long Break") { timer.start(kind: .longBreak) }
            case .running:
                Button("Pause") { timer.pause() }
                    .buttonStyle(.borderedProminent)
                Button("Reset") { timer.reset() }
            case .paused:
                Button("Resume") { timer.resume() }
                    .buttonStyle(.borderedProminent)
                Button("Reset") { timer.reset() }
            }
        }
    }

    private func label(for kind: PomodoroSession.Kind) -> String {
        switch kind {
        case .work:        return "Work"
        case .shortBreak:  return "Short break"
        case .longBreak:   return "Long break"
        }
    }
}
