//
//  ClaudeTestApp.swift
//  ClaudeTest
//
//  Created by Malik Abdul Ghani on 06/04/26.
//

import SwiftUI

@main
struct ClaudeTestApp: App {
    @StateObject private var appState = AppState()

    init() {
        AppLogger.shared.log("App launched")
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .preferredColorScheme(appState.colorScheme)
        }
    }
}

final class AppState: ObservableObject {
    @Published var colorScheme: ColorScheme? = nil
    @Published var isFirstLaunch: Bool

    init() {
        let key = "hasLaunchedBefore"
        let defaults = UserDefaults.standard
        self.isFirstLaunch = !defaults.bool(forKey: key)
        defaults.set(true, forKey: key)
    }

    func toggleColorScheme() {
        switch colorScheme {
        case .none: colorScheme = .dark
        case .some(.dark): colorScheme = .light
        default: colorScheme = nil
        }
    }
}

struct AppLogger {
    static let shared = AppLogger()

    func log(_ message: String, file: String = #file, line: Int = #line) {
        let filename = (file as NSString).lastPathComponent
        print("[ClaudeTest] \(filename):\(line) — \(message)")
    }
}
