//
//  PomodoroSettings.swift
//  ClaudeTest
//

import Foundation

struct PomodoroSettings: Codable, Equatable {
    var workMinutes: Int
    var shortBreakMinutes: Int
    var longBreakMinutes: Int
    var sessionsBeforeLongBreak: Int

    static let defaults = PomodoroSettings(
        workMinutes: 25,
        shortBreakMinutes: 5,
        longBreakMinutes: 15,
        sessionsBeforeLongBreak: 4
    )

    mutating func setWorkMinutes(_ value: Int) {
        workMinutes = value
    }

    mutating func setShortBreakMinutes(_ value: Int) {
        shortBreakMinutes = value
    }

    mutating func setLongBreakMinutes(_ value: Int) {
        longBreakMinutes = value
    }
}
