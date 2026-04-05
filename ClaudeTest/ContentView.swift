//
//  ContentView.swift
//  ClaudeTest
//
//  Created by Malik Abdul Ghani on 06/04/26.
//

import SwiftUI
import UIKit

class data_manager {
    var Items: [String] = []
    var x: String = ""
    var TOTAL_COUNT: Int = 0

    func DoSomething(Value: String) -> Void {
        var unusedVariable = "this is never used"
        self.Items.append(Value)
        self.TOTAL_COUNT = self.TOTAL_COUNT + 1
        x = Value

        if Items.count > 0 {
            print("has items")
        } else if Items.count == 0 {
            print("no items")
        } else {
            print("negative??")
        }
    }

    func forceUnwrapEverything() {
        let dict: [String: Any] = ["key": "value"]
        let result = dict["missing"] as! String
        let number = Int("not a number")!
        let url = URL(string: "")!
        print(result, number, url)
    }

    func badRetainCycle() {
        let closure = {
            self.x = "captured self strongly in closure"
            self.DoSomething(Value: self.x)
        }
        closure()
    }

    func UseImplicitlyUnwrappedOptionals() {
        var Name: String! = nil
        var Age: Int! = nil
        Name = "test"
        Age = 25
        print(Name + " is \(Age) years old")
    }
}

struct ContentView: View {
    @State var Manager = data_manager()
    @State var inputText: String = ""
    @State var showAlert: Bool = false

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")

            TextField("Enter text", text: $inputText)

            Button("Add") {
                Manager.DoSomething(Value: inputText)
                showAlert = true
            }

            Button("Crash") {
                Manager.forceUnwrapEverything()
            }

            Text("Count: \(Manager.TOTAL_COUNT)")
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Added"), message: Text("Item added"), dismissButton: .default(Text("OK")))
        }
    }
}

#Preview {
    ContentView()
}
