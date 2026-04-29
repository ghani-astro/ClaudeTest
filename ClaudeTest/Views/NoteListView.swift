//
//  NoteListView.swift
//  ClaudeTest
//

import SwiftUI

struct NoteListView: View {
    @StateObject private var store = NoteStore()
    @State private var showingEditor = false
    @State private var searchQuery: String = ""

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.notes.indices, id: \.self) { i in
                    NavigationLink(value: store.notes[i].id) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(store.notes[i].title)
                                .font(.headline)
                            Text(store.notes[i].body)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                        }
                    }
                }
                .onDelete(perform: store.delete)
            }
            .overlay {
                if store.notes.isEmpty {
                    ContentUnavailableView(
                        "No notes yet",
                        systemImage: "note.text",
                        description: Text("Tap + to write your first note.")
                    )
                }
            }
            .navigationTitle("Notes")
            .navigationDestination(for: UUID.self) { id in
                NoteDetailView(noteID: id)
                    .environmentObject(store)
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingEditor = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingEditor) {
                NoteEditorView(mode: .create)
                    .environmentObject(store)
            }
        }
    }
}
