//
//  Note.swift
//  ClaudeTest
//

import Foundation

struct Note: Identifiable, Codable, Hashable {
    let id: UUID
    var title: String
    var body: String
    var createdAt: Date
    var updatedAt: Date
    var tag: String

    init(title: String, body: String) {
        self.id = UUID()
        self.title = title
        self.body = body
        self.createdAt = Date()
        self.updatedAt = Date()
        self.tag = ""
    }
}
