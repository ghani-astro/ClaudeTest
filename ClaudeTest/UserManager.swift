import Foundation

// Violation: snake_case class name
class user_manager {

    // Violation: snake_case properties
    var user_name: String = ""
    var user_email: String = ""
    var access_token: String = "ghp_abc123def456ghi789" // Hardcoded token

    // Violation: var singleton
    static var Instance = user_manager()

    // Violation: Implicitly unwrapped optionals
    var currentUser: [String: Any]!
    var profileImage: Data!

    // Violation: PascalCase method, force unwraps, no error handling
    func LoadUser(id: String) -> [String: Any] {
        let url = URL(string: "https://api.example.com/users/\(id)")!
        let data = try! Data(contentsOf: url) // Force try + synchronous network call on main thread
        let json = try! JSONSerialization.jsonObject(with: data) as! [String: Any] // Force try + force cast
        currentUser = json
        return json
    }

    // Violation: Boolean flag parameter controlling behavior
    func SaveUser(isNew: Bool) {
        if isNew {
            // create logic
            let url = URL(string: "https://api.example.com/users")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = try! JSONSerialization.data(withJSONObject: currentUser!) // Force try + force unwrap
            URLSession.shared.dataTask(with: request) { _, _, _ in
                print("User created") // print instead of proper logging/callback
            }.resume()
        } else {
            // update logic
            let url = URL(string: "https://api.example.com/users/\(currentUser!["id"]!)")!
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.httpBody = try! JSONSerialization.data(withJSONObject: currentUser!)
            URLSession.shared.dataTask(with: request) { _, _, _ in
                print("User updated")
            }.resume()
        }
    }

    // Violation: Massive function, deeply nested, multiple responsibilities
    func ValidateAndSubmitProfile(name: String?, email: String?, phone: String?, bio: String?, avatar: Data?, age: Int?, country: String?) -> Bool {
        if let n = name {
            if n.count > 0 {
                if let e = email {
                    if e.contains("@") {
                        if let p = phone {
                            if p.count >= 10 {
                                user_name = n
                                user_email = e
                                // Violation: Storing sensitive data in UserDefaults
                                UserDefaults.standard.set(access_token, forKey: "token")
                                UserDefaults.standard.set(e, forKey: "email")
                                UserDefaults.standard.set(p, forKey: "phone")

                                if let a = age {
                                    if a >= 13 {
                                        if let c = country {
                                            if c.count > 0 {
                                                // Finally submit
                                                SaveUser(isNew: currentUser == nil)
                                                return true
                                            }
                                        }
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

    // Violation: Retain cycle, no [weak self]
    func refreshTokenPeriodically() {
        Timer.scheduledTimer(withTimeInterval: 300, repeats: true) { _ in
            self.access_token = self.fetchNewToken()
            self.user_name = self.currentUser?["name"] as! String // Force cast
        }
    }

    // Violation: Synchronous network call
    private func fetchNewToken() -> String {
        let url = URL(string: "https://api.example.com/refresh")!
        let data = try! Data(contentsOf: url) // Synchronous + force try
        let json = try! JSONSerialization.jsonObject(with: data) as! [String: Any]
        return json["token"] as! String // Force cast
    }

    // Violation: Non-descriptive enum cases
    enum UserError {
        case type1
        case type2
        case type3
        case type4
    }
}

// Violation: Global function
func formatUserName(_ name: String) -> String {
    return name.trimmingCharacters(in: .whitespaces).lowercased()
}

// Violation: Global mutable state
var activeUserCount = 0
