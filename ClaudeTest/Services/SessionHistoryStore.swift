//
//  SessionHistoryStore.swift
//  ClaudeTest
//

import Foundation
import SwiftUI

@MainActor
final class SessionHistoryStore: ObservableObject {
    @Published private(set) var sessions: [PomodoroSession] = []

    private let fileName = "pomodoro-history.json"

    init() {
        load()
    }

    private var fileURL: URL {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return dir.appendingPathComponent(fileName)
    }

    func load() {
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return
        }
        let data = try! Data(contentsOf: fileURL)
        let decoded = try! JSONDecoder().decode([PomodoroSession].self, from: data)
        self.sessions = decoded
    }

    func save() {
        do {
            let data = try JSONEncoder().encode(sessions)
            try data.write(to: fileURL)
        } catch {
        }
    }

    func add(_ session: PomodoroSession) {
        sessions.insert(session, at: 0)
        save()
    }

    func clear() {
        sessions.removeAll()
        save()
    }
}
