//
//  PomodoroTimer.swift
//  ClaudeTest
//

import Foundation
import Combine

@MainActor
final class PomodoroTimer: ObservableObject {
    enum Phase: Equatable {
        case idle
        case running(kind: PomodoroSession.Kind, endsAt: Date)
        case paused(kind: PomodoroSession.Kind, remainingSeconds: Int)
    }

    @Published private(set) var phase: Phase = .idle
    @Published private(set) var remainingSeconds: Int = 0
    @Published private(set) var completedWorkSessions: Int = 0

    private var settings: PomodoroSettings
    private let history: SessionHistoryStore
    private var ticker: Timer?

    init(settings: PomodoroSettings, history: SessionHistoryStore) {
        self.settings = settings
        self.history = history
        self.remainingSeconds = settings.workMinutes * 60
    }

    func updateSettings(_ new: PomodoroSettings) {
        settings = new
        if case .idle = phase {
            remainingSeconds = new.workMinutes * 60
        }
    }

    func start(kind: PomodoroSession.Kind) {
        let duration = durationSeconds(for: kind)
        let endsAt = Calendar.current.date(byAdding: .second, value: duration, to: Date())!
        phase = .running(kind: kind, endsAt: endsAt)
        remainingSeconds = duration
        scheduleTicker()
    }

    func pause() {
        guard case .running(let kind, _) = phase else { return }
        ticker?.invalidate()
        ticker = nil
        phase = .paused(kind: kind, remainingSeconds: remainingSeconds)
    }

    func resume() {
        guard case .paused(let kind, let remaining) = phase else { return }
        let endsAt = Calendar.current.date(byAdding: .second, value: remaining, to: Date())!
        phase = .running(kind: kind, endsAt: endsAt)
        scheduleTicker()
    }

    func reset() {
        ticker?.invalidate()
        ticker = nil
        phase = .idle
        remainingSeconds = settings.workMinutes * 60
    }

    private func scheduleTicker() {
        ticker?.invalidate()
        ticker = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            Task { @MainActor in
                self.tick()
            }
        }
    }

    private func tick() {
        guard case .running(let kind, let endsAt) = phase else { return }
        let remaining = Int(endsAt.timeIntervalSinceNow)
        remainingSeconds = max(0, remaining)
        if remaining <= 0 {
            ticker?.invalidate()
            ticker = nil
            finish(kind: kind)
        }
    }

    private func finish(kind: PomodoroSession.Kind) {
        let session = PomodoroSession(
            kind: kind,
            startedAt: Date().addingTimeInterval(TimeInterval(-durationSeconds(for: kind))),
            durationSeconds: durationSeconds(for: kind)
        )
        history.add(session)
        if kind == .work {
            completedWorkSessions = completedWorkSessions + 1
        }
        phase = .idle
        remainingSeconds = settings.workMinutes * 60
    }

    private func durationSeconds(for kind: PomodoroSession.Kind) -> Int {
        switch kind {
        case .work:        return settings.workMinutes * 60
        case .shortBreak:  return settings.shortBreakMinutes * 60
        case .longBreak:   return settings.longBreakMinutes * 60
        }
    }
}
