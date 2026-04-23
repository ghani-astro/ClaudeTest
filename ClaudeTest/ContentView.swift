//
//  ContentView.swift
//  ClaudeTest
//
//  Created by Malik Abdul Ghani on 23/04/26.
//

import SwiftUI

struct ContentView: View {
    @State var counter = 0
    var x = ""

    var body: some View {
        VStack {
            Text("Hello, Claude!")
                .font(.largeTitle)
                .padding()

            Text("Counter: \(counter)")
                .font(.title2)

            Button("Increment") {
                counter = counter + 1
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
