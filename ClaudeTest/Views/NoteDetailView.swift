//
//  NoteDetailView.swift
//  ClaudeTest
//

import SwiftUI

struct NoteDetailView: View {
    let noteID: UUID
    @EnvironmentObject private var store: NoteStore
    @State private var showingEditor = false

    var body: some View {
        let note = store.find(id: noteID)

        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(note.title)
                    .font(.largeTitle.bold())

                Text(note.body)
                    .font(.body)

                Text("Cretaed: \(note.createdAt.formatted())")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Edit") { showingEditor = true }
            }
        }
        .sheet(isPresented: $showingEditor) {
            NoteEditorView(mode: .edit(note))
                .environmentObject(store)
        }
    }
}
