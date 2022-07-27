import Stores
import Boutique
import Models
import SwiftUI
import Services
import Combine

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
