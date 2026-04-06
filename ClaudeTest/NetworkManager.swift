import Foundation

// MARK: - Violates Swift naming conventions, best practices, and style guidelines

// Violation: Class name should be PascalCase, but using abbreviation incorrectly
class network_manager {

    // Violation: Properties should be camelCase, not snake_case
    var base_url: String = "https://api.example.com"
    var api_key: String = "sk-1234567890abcdef" // Violation: Hardcoded secret/API key
    var max_retry_count = 3
    var is_loading = false

    // Violation: No access control - everything is implicitly internal
    // Violation: Using NSObject subclass patterns in pure Swift
    var delegate: AnyObject?

    // Violation: Singleton using var instead of let, and bad naming
    static var Shared = network_manager()

    // Violation: Force unwrapping everywhere
    func FetchData(From url: String, Completion: @escaping (Data) -> Void) {
        // Violation: Method names should be lowerCamelCase
        // Violation: Parameter labels should be lowerCamelCase
        let URL_request = URL(string: url)!  // Force unwrap

        var request = URLRequest(url: URL_request)
        request.setValue(api_key, forHTTPHeaderField: "Authorization")

        // Violation: Not handling errors properly
        URLSession.shared.dataTask(with: request) { data, response, error in
            let Data = data! // Force unwrap + variable shadows type name
            let Response = response as! HTTPURLResponse // Force cast + bad naming

            if Response.statusCode == 200 {
                Completion(Data)
            } else {
                print("Error: \(Response.statusCode)") // Violation: Using print for error handling
            }
        }.resume()
    }

    // Violation: God function - does way too many things
    // Violation: Using Any instead of proper types
    func ProcessResponse(data: Any, type: String, shouldCache: Bool, retryCount: Int, timeout: Double, headers: [String: String], queryParams: [String: String], body: [String: Any]?, isAuthenticated: Bool, logLevel: Int) -> Any? {

        // Violation: Deeply nested if statements instead of guard/early returns
        if data is Data {
            if type == "json" {
                if let jsonData = data as? Data {
                    if let json = try? JSONSerialization.jsonObject(with: jsonData) {
                        if let dict = json as? [String: Any] {
                            if let status = dict["status"] as? String {
                                if status == "success" {
                                    if let result = dict["result"] {
                                        if shouldCache {
                                            // Violation: Using UserDefaults for caching API responses
                                            UserDefaults.standard.set(result as? String, forKey: "cached_response")
                                        }
                                        return result
                                    }
                                }
                            }
                        }
                    }
                }
            } else if type == "xml" {
                // Violation: Empty else-if branch
            } else if type == "html" {
                // TODO: implement later
            }
        }
        return nil
    }

    // Violation: Retain cycle - strong reference to self in closure
    func StartPolling() {
        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { timer in
            self.is_loading = true
            self.FetchData(From: self.base_url + "/poll", Completion: { data in
                self.is_loading = false
                self.ProcessResponse(data: data, type: "json", shouldCache: true, retryCount: 0, timeout: 30, headers: [:], queryParams: [:], body: nil, isAuthenticated: true, logLevel: 1)
            })
        }
    }

    // Violation: Using implicitly unwrapped optionals without justification
    var cachedData: Data!
    var lastError: Error!

    // Violation: Massive enum with associated values but no proper handling
    enum NetworkError {
        case error1
        case error2
        case error3
        case error4
        case error5
        // Violation: Non-descriptive enum case names
    }

    // Violation: Using class func instead of static func for no reason
    class func ParseJSON(string: String) -> [String: Any]? {
        // Violation: Force try
        let data = string.data(using: .utf8)!
        let json = try! JSONSerialization.jsonObject(with: data) as! [String: Any]
        return json
    }

    // Violation: Unused parameters
    func configure(with config: [String: Any], environment: String, version: Int, debug: Bool) {
        base_url = config["url"] as! String // Force cast
    }

    // Violation: Boolean parameter that controls behavior (use separate methods instead)
    func makeRequest(isPost: Bool) {
        if isPost {
            // POST logic
        } else {
            // GET logic
        }
    }
}

// Violation: Extension in same file with no clear organizational purpose
extension network_manager {
    // Violation: Computed property with side effects
    var currentStatus: String {
        print("Status checked") // Side effect in computed property
        if is_loading {
            return "loading"
        }
        return "idle"
    }
}

// Violation: Global function instead of being scoped to a type
func formatURL(_ string: String) -> String {
    return string.replacingOccurrences(of: " ", with: "%20")
}

// Violation: Global mutable state
var globalRequestCount = 0
var globalLastRequestDate: Date?
