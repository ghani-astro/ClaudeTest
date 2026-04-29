//
//  HistoryView.swift
//  ClaudeTest
//

import SwiftUI

struct HistoryView: View {
    @EnvironmentObject private var history: SessionHistoryStore
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                if history.sessions.isEmpty {
                    Text("No sesssions yet")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(history.sessions.indices, id: \.self) { i in
                        let session = history.sessions[i]
                        HistoryRow(session: session, label: label(for: session.kind))
                    }
                }
            }
            .navigationTitle("History")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Clear") { history.clear() }
                        .disabled(history.sessions.isEmpty)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }

    private func label(for kind: PomodoroSession.Kind) -> String {
        switch kind {
        case .work:        return "Work"
        case .shortBreak:  return "Short Break"
        case .longBreak:   return "Long Break"
        }
    }
}

private struct HistoryRow: View {
    let session: PomodoroSession
    let label: String

    var body: some View {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short

        return VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(label).font(.headline)
                Spacer()
                Text("\(session.durationSeconds / 60) min")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Text(formatter.string(from: session.startedAt))
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}
