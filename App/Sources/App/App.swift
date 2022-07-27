import SwiftUI
import Boutique
import Models
import Stores
import EpisodesListComponent

@MainActor
public final class AppController: ObservableObject {
    public private(set) var episodesController: EpisodesController

    public init() {
        episodesController = .init(store: .episodes, favorites: .favorites)
    }

    public func start() async {
//        await episodesController.fetchEpisodes()
    }
}
