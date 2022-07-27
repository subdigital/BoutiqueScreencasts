import Stores
import Boutique
import Models
import SwiftUI
import Services
import Combine

@MainActor
@propertyWrapper
public struct StoredSingle<Object: Codable & Equatable> {

    private let box: Box

    public init(in store: Store<Object>) {
        self.box = Box(store)
    }

    public var wrappedValue: Object? {
        box.store.items.first
    }

    public var projectedValue: Store<Object> {
        box.store
    }

    public func save(_ object: Object) async throws {
        try await box.store.add(object)
    }

    public static subscript<Instance: ObservableObject>(
        _enclosingInstance instance: Instance,
        wrapped wrappedKeyPath: KeyPath<Instance, Object?>,
        storage storageKeyPath: KeyPath<Instance, Self>
    ) -> Object?
    where Instance.ObjectWillChangePublisher == ObservableObjectPublisher
    {
        let propertyWrapper = instance[keyPath: storageKeyPath]
        if propertyWrapper.box.cancellable == nil {
            let store = propertyWrapper.projectedValue
            propertyWrapper.box.cancellable = store.objectWillChange
                .sink(receiveValue: { [willChange = instance.objectWillChange] in
                    willChange.send()
                })
        }

        return propertyWrapper.wrappedValue
    }

    private class Box {
        let store: Store<Object>
        var cancellable: AnyCancellable?
        init(_ store: Store<Object>) {
            self.store = store
        }
    }
}


@MainActor
public final class EpisodesController: ObservableObject {
    @Stored var episodes: [Episode]
    @StoredSingle var favorites: UserFavorites?

    var sortedEpisodes: [Episode] {
        episodes.sorted().reversed()
    }

    private let service: EpisodeService

    public init(store: Store<Episode>, favorites: Store<UserFavorites>, service: EpisodeService = .live()) {
        _episodes = Stored(in: store)
        _favorites = StoredSingle(in: favorites)
        self.service = service
    }

    public func fetchEpisodes() async {
        do {
            let episodes = try await service.fetchEpisodes()
            try await $episodes.add(episodes, removingExistingItems: .all)
        } catch CocoaError.userCancelled {
            /* no-op */
        } catch {
            print("Error fetching episodes: \(error)")
        }
    }

    func detailController(for episode: Episode) -> EpisodeDetailController {
        .init(episode: episode, store: $favorites)
    }

    func isFavorite(episode: Episode) -> Bool {
        favorites?.episodeIDs.contains(episode.id) ?? false
    }
}
