//
//  ContentView.swift
//  ClaudeTest
//
//  Created by Malik Abdul Ghani on 24/04/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ItemListViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading && viewModel.items.isEmpty {
                    ProgressView("Loading…")
                } else {
                    itemList
                }
            }
            .navigationTitle("Items")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Text("\(viewModel.favoriteCount) ★")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .task { await viewModel.load() }
            .alert(
                "Something went wrong",
                isPresented: Binding(
                    get: { viewModel.errorMessage != nil },
                    set: { if !$0 { viewModel.errorMessage = nil } }
                ),
                actions: { Button("OK", role: .cancel) {} },
                message: { Text(viewModel.errorMessage ?? "") }
            )
        }
    }

    private var itemList: some View {
        List(viewModel.items) { item in
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title).font(.headline)
                    Text(item.subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Button {
                    Task { await viewModel.toggleFavorite(item) }
                } label: {
                    Image(systemName: item.isFavorite ? "star.fill" : "star")
                        .foregroundStyle(item.isFavorite ? .yellow : .gray)
                }
                .buttonStyle(.borderless)
            }
            .padding(.vertical, 4)
        }
        .refreshable { await viewModel.load() }
    }
}

#Preview {
    ContentView()
}
