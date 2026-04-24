//
//  Item.swift
//  ClaudeTest
//
//  Created by Malik Abdul Ghani on 24/04/26.
//

import Foundation

struct Item: Identifiable, Hashable, Codable {
    let id: UUID
    let title: String
    let subtitle: String
    let createdAt: Date
    var isFavorite: Bool

    init(
        id: UUID = UUID(),
        title: String,
        subtitle: String,
        createdAt: Date = Date(),
        isFavorite: Bool = false
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.createdAt = createdAt
        self.isFavorite = isFavorite
    }
}

extension Item {
    static let samples: [Item] = [
        Item(title: "Welcome to ClaudeTest", subtitle: "A small SwiftUI playground"),
        Item(title: "MVVM", subtitle: "Model, View, ViewModel"),
        Item(title: "Async/Await", subtitle: "Structured concurrency"),
        Item(title: "Swift Concurrency", subtitle: "Tasks and actors"),
        Item(title: "Combine", subtitle: "Reactive streams")
    ]
}
