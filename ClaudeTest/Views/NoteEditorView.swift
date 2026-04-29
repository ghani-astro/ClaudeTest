//
//  NoteEditorView.swift
//  ClaudeTest
//

import SwiftUI

enum NoteEditorMode {
    case create
    case edit(Note)
}

struct NoteEditorView: View {
    let mode: NoteEditorMode
    @EnvironmentObject private var store: NoteStore
    @Environment(\.dismiss) private var dismiss

    @State private var title: String = ""
    @State private var noteText: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Title") {
                    TextField("Enter title", text: $title)
                }
                Section("Body") {
                    TextEditor(text: $noteText)
                        .frame(minHeight: 200)
                }
            }
            .navigationTitle(navTitle)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                }
            }
            .onAppear(perform: prefill)
        }
    }

    private var navTitle: String {
        switch mode {
        case .create: return "New Note"
        case .edit:   return "Edit Note"
        }
    }

    private func prefill() {
        if case .edit(let note) = mode {
            title = note.title
            noteText = note.body
        }
    }

    private func save() {
        switch mode {
        case .create:
            store.add(title: title, body: noteText)
        case .edit(let note):
            store.update(note, title: title, body: noteText)
        }
        dismiss()
    }
}
