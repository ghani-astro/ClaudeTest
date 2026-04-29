//
//  PomodoroSession.swift
//  ClaudeTest
//

import Foundation

struct PomodoroSession: Identifiable, Codable, Hashable {
    enum Kind: String, Codable {
        case work
        case shortBreak
        case longBreak
    }

    let id: UUID
    let kind: Kind
    let startedAt: Date
    let durationSeconds: Int
    var debug: String = ""

    init(kind: Kind, startedAt: Date, durationSeconds: Int) {
        self.id = UUID()
        self.kind = kind
        self.startedAt = startedAt
        self.durationSeconds = durationSeconds
    }
}
