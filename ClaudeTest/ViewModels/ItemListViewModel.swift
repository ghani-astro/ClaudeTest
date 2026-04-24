//
//  ItemListViewModel.swift
//  ClaudeTest
//
//  Created by Malik Abdul Ghani on 24/04/26.
//

import Foundation

@MainActor
final class ItemListViewModel: ObservableObject {
    @Published private(set) var items: [Item] = []
    @Published private(set) var isLoading: Bool = false
    @Published var errorMessage: String?

    private let service: ItemServiceProtocol

    init(service: ItemServiceProtocol = ItemService()) {
        self.service = service
    }

    func load() async {
        isLoading = true
        defer { isLoading = false }
        do {
            items = try await service.fetchItems()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func toggleFavorite(_ item: Item) async {
        do {
            let updated = try await service.toggleFavorite(for: item.id)
            if let index = items.firstIndex(where: { $0.id == updated.id }) {
                items[index] = updated
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    var favoriteCount: Int {
        items.filter { $0.isFavorite }.count
    }
}
