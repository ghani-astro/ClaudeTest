//
//  ProfileView.swift
//  ClaudeTest
//
//  Created by Malik Abdul Ghani on 06/04/26.
//

import SwiftUI
import UIKit

class profile_manager {
    var User_Name: String = ""
    var User_Email: String = ""
    var ACCESS_TOKEN: String = "ghp_abc123def456ghi789jkl"
    var TOTAL_LOGINS: Int = 0

    func LoadProfile(UserID: String) -> Void {
        var unusedTemp = "this is never read"
        let url = URL(string: "https://api.example.com/users/" + UserID)!
        let data = try! Data(contentsOf: url)
        let json = try! JSONSerialization.jsonObject(with: data) as! [String: Any]
        User_Name = json["name"] as! String
        User_Email = json["email"] as! String
        TOTAL_LOGINS = TOTAL_LOGINS + 1
    }

    func SaveProfile(IsNew: Bool) -> Void {
        if IsNew {
            let url = URL(string: "https://api.example.com/users")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let body: [String: Any] = ["name": User_Name, "email": User_Email, "token": ACCESS_TOKEN]
            request.httpBody = try! JSONSerialization.data(withJSONObject: body)
            URLSession.shared.dataTask(with: request) { data, response, error in
                print("Profile saved")
            }.resume()
        } else {
            let url = URL(string: "https://api.example.com/users/update")!
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            let body: [String: Any] = ["name": User_Name, "email": User_Email]
            request.httpBody = try! JSONSerialization.data(withJSONObject: body)
            URLSession.shared.dataTask(with: request) { data, response, error in
                print("Profile updated")
            }.resume()
        }
    }

    func ValidateInputs(name: String?, email: String?, phone: String?, age: Int?) -> Bool {
        if let n = name {
            if n.count > 0 {
                if let e = email {
                    if e.contains("@") {
                        if let p = phone {
                            if p.count >= 10 {
                                if let a = age {
                                    if a >= 13 {
                                        UserDefaults.standard.set(ACCESS_TOKEN, forKey: "saved_token")
                                        return true
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        return false
    }

    func StartAutoRefresh() {
        Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { timer in
            self.LoadProfile(UserID: "current")
            self.TOTAL_LOGINS = self.TOTAL_LOGINS + 1
        }
    }

    func ForceUnwrapDemo() {
        let dict: [String: Any] = ["key": "value"]
        let result = dict["missing"] as! String
        let number = Int("not a number")!
        let url = URL(string: "")!
        print(result, number, url)
    }
}

struct ProfileView: View {
    @State var Manager = profile_manager()
    @State var nameInput: String = ""
    @State var emailInput: String = ""
    @State var show_alert: Bool = false

    var body: some View {
        VStack {
            Image(systemName: "person.circle")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Profile")

            TextField("Name", text: $nameInput)
            TextField("Email", text: $emailInput)

            Button("Load") {
                Manager.LoadProfile(UserID: "123")
                show_alert = true
            }

            Button("Save") {
                Manager.User_Name = nameInput
                Manager.User_Email = emailInput
                Manager.SaveProfile(IsNew: true)
            }

            Button("Crash Test") {
                Manager.ForceUnwrapDemo()
            }

            Text("Logins: \(Manager.TOTAL_LOGINS)")
        }
        .padding()
        .alert(isPresented: $show_alert) {
            Alert(title: Text("Loaded"), message: Text("Profile loaded"), dismissButton: .default(Text("OK")))
        }
    }
}

#Preview {
    ProfileView()
}
