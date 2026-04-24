//
//  ItemService.swift
//  ClaudeTest
//
//  Created by Malik Abdul Ghani on 24/04/26.
//

import Foundation

protocol ItemServiceProtocol {
    func fetchItems() async throws -> [Item]
    func toggleFavorite(for id: UUID) async throws -> Item
}

enum ItemServiceError: Error, LocalizedError {
    case notFound
    case offline

    var errorDescription: String? {
        switch self {
        case .notFound: return "Item not found."
        case .offline: return "Network unavailable. Please try again."
        }
    }
}

final class ItemService: ItemServiceProtocol {
    private var cache: [Item]

    init(initial: [Item] = Item.samples) {
        self.cache = initial
    }

    func fetchItems() async throws -> [Item] {
        try await Task.sleep(nanoseconds: 250_000_000)
        return cache
    }

    func toggleFavorite(for id: UUID) async throws -> Item {
        guard let index = cache.firstIndex(where: { $0.id == id }) else {
            throw ItemServiceError.notFound
        }
        cache[index].isFavorite.toggle()
        return cache[index]
    }
}
