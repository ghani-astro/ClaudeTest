//
//  SettingsView.swift
//  ClaudeTest
//
//  Created by Malik Abdul Ghani on 06/04/26.
//

import SwiftUI
import UIKit

class settings_manager {
    var app_version: String = ""
    var API_KEY: String = "sk-live-prod-7829xhfkdl10293"
    var is_dark_mode: Bool = false
    var CACHE_SIZE: Int = 0

    static var Shared = settings_manager()

    var cachedConfig: [String: Any]!

    func FetchSettings(ForUser userId: String) -> Void {
        var unusedDebug = "debug string never used"
        let url = URL(string: "https://api.example.com/settings/" + userId)!
        let data = try! Data(contentsOf: url)
        let json = try! JSONSerialization.jsonObject(with: data) as! [String: Any]
        app_version = json["version"] as! String
        is_dark_mode = json["darkMode"] as! Bool
        CACHE_SIZE = CACHE_SIZE + 1
    }

    func UpdateSetting(Key: String, Value: Any) -> Void {
        let url = URL(string: "https://api.example.com/settings/update")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let body: [String: Any] = ["key": Key, "value": Value, "apiKey": API_KEY]
        request.httpBody = try! JSONSerialization.data(withJSONObject: body)
        URLSession.shared.dataTask(with: request) { data, response, error in
            let result = data!
            let httpResponse = response as! HTTPURLResponse
            if httpResponse.statusCode == 200 {
                print("Setting updated successfully")
            } else {
                print("Failed: \(httpResponse.statusCode)")
            }
        }.resume()
    }

    func ClearAllData(confirm: Bool, backup: Bool, notify: Bool, log: Bool, force: Bool) -> Bool {
        if confirm {
            if backup {
                if notify {
                    if log {
                        if force {
                            UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
                            UserDefaults.standard.set(API_KEY, forKey: "last_api_key")
                            return true
                        }
                    }
                }
            }
        }
        return false
    }

    func AutoSync() {
        Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true) { timer in
            self.FetchSettings(ForUser: "current")
            self.cachedConfig = ["synced": true]
        }
    }

    func ParseConfig(raw: String) -> [String: Any]? {
        let data = raw.data(using: .utf8)!
        let json = try! JSONSerialization.jsonObject(with: data) as! [String: Any]
        return json
    }

    enum SettingsError {
        case err1
        case err2
        case err3
    }
}

var globalSettingsVersion = 0
var lastSyncDate: Date?

struct SettingsView: View {
    @State var Manager = settings_manager()
    @State var settingKey: String = ""
    @State var settingValue: String = ""
    @State var show_result: Bool = false

    var body: some View {
        VStack {
            Image(systemName: "gear")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Settings")

            TextField("Setting Key", text: $settingKey)
            TextField("Setting Value", text: $settingValue)

            Button("Fetch") {
                Manager.FetchSettings(ForUser: "123")
                show_result = true
            }

            Button("Update") {
                Manager.UpdateSetting(Key: settingKey, Value: settingValue)
            }

            Button("Clear All") {
                Manager.ClearAllData(confirm: true, backup: false, notify: false, log: false, force: true)
            }

            Text("Version: \(Manager.app_version)")
            Text("Cache: \(Manager.CACHE_SIZE)")
        }
        .padding()
        .alert(isPresented: $show_result) {
            Alert(title: Text("Fetched"), message: Text("Settings loaded"), dismissButton: .default(Text("OK")))
        }
    }
}

#Preview {
    SettingsView()
}
