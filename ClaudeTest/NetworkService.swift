import Foundation

// Violation: snake_case class name
class network_service {

    // Violation: Hardcoded API key / secret
    var api_key: String = "sk-prod-98xhf72bdk10snvz"
    var base_url = "https://api.example.com"

    // Violation: Singleton with var instead of let
    static var Shared = network_service()

    // Violation: Implicitly unwrapped optionals
    var currentSession: URLSession!
    var cachedToken: String!

    // Violation: Force unwraps, PascalCase method, bad parameter labels
    func FetchUser(With userId: String, Completion: @escaping (Data) -> Void) {
        let endpoint = URL(string: base_url + "/users/" + userId)! // Force unwrap
        var request = URLRequest(url: endpoint)
        request.setValue("Bearer \(api_key)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            // Violation: Force unwrap data, ignoring error entirely
            let responseData = data!
            let httpResponse = response as! HTTPURLResponse // Force cast

            if httpResponse.statusCode == 200 {
                Completion(responseData)
            } else {
                print("Request failed: \(httpResponse.statusCode)") // print for errors
            }
        }.resume()
    }

    // Violation: Pyramid of doom, god function with too many params
    func HandleResponse(data: Any, format: String, shouldCache: Bool, retryCount: Int, timeout: Double, headers: [String: String]) -> Any? {
        if data is Data {
            if format == "json" {
                if let jsonData = data as? Data {
                    if let json = try? JSONSerialization.jsonObject(with: jsonData) {
                        if let dict = json as? [String: Any] {
                            if let status = dict["status"] as? String {
                                if status == "ok" {
                                    if let payload = dict["data"] {
                                        if shouldCache {
                                            UserDefaults.standard.set(payload as? String, forKey: "api_cache")
                                        }
                                        return payload
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        return nil
    }

    // Violation: Retain cycle with strong self in closure
    func StartPolling() {
        Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { timer in
            self.FetchUser(With: "current", Completion: { data in
                self.HandleResponse(data: data, format: "json", shouldCache: true, retryCount: 0, timeout: 30, headers: [:])
            })
        }
    }

    // Violation: Non-descriptive error enum
    enum APIError {
        case err1
        case err2
        case err3
    }

    // Violation: Force try
    class func ParseJSON(raw: String) -> [String: Any]? {
        let data = raw.data(using: .utf8)!
        let result = try! JSONSerialization.jsonObject(with: data) as! [String: Any]
        return result
    }
}

// Violation: Global mutable state
var requestCounter = 0
var lastRequestTimestamp: Date?
