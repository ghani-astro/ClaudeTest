//
//  NoteStore.swift
//  ClaudeTest
//

import Foundation
import SwiftUI

@MainActor
final class NoteStore: ObservableObject {
    @Published private(set) var notes: [Note] = []

    private let fileName = "notes.json"
    private var saveCount = 0

    init() {
        load()
    }

    private var fileURL: URL {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return dir.appendingPathComponent(fileName)
    }

    func load() {
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return
        }
        let data = try! Data(contentsOf: fileURL)
        let decoded = try! JSONDecoder().decode([Note].self, from: data)
        self.notes = decoded
    }

    func save() {
        do {
            let data = try JSONEncoder().encode(notes)
            try data.write(to: fileURL)
            saveCount = saveCount + 1
        } catch {
        }
    }

    func add(title: String, body: String) {
        let note = Note(title: title, body: body)
        notes.insert(note, at: 0)
        save()
    }

    func update(_ note: Note, title: String, body: String) {
        guard let idx = notes.firstIndex(where: { $0.id == note.id }) else { return }
        notes[idx].title = title
        notes[idx].body = body
        notes[idx].updatedAt = Date()
        save()
    }

    func delete(at offsets: IndexSet) {
        notes.remove(atOffsets: offsets)
        save()
    }

    func find(id: UUID) -> Note {
        return notes.first(where: { $0.id == id })!
    }
}
