import Boutique
import SwiftUI
import Combine
import Models
import Stores

@MainActor
public final class EpisodeDetailController: ObservableObject {
    @Published var episode: Episode
    @StoredSingle var favorites: UserFavorites?

    init(episode: Episode, store: Store<UserFavorites>) {
        self.episode = episode
        _favorites = StoredSingle(in: store)
    }

    var isFavorite: Bool {
        favorites?.episodeIDs.contains(episode.id) ?? false
    }

    func toggleFavorite() async {
        do {
            var favs = favorites ?? UserFavorites()
            if isFavorite {
                favs.episodeIDs.remove(episode.id)
            } else {
                favs.episodeIDs.insert(episode.id)
            }
            try await _favorites.save(favs)
        } catch {
            print("Error togging favorite: \(error)")
        }
    }

    var favoritesButtonTitle: String {
        isFavorite ? "Remove from favorites" : "Add to favorites"
    }
}
