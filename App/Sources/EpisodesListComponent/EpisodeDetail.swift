import SwiftUI
import Models
import Boutique
import Bodega

public struct EpisodeDetail: View {
    @ObservedObject var controller: EpisodeDetailController
    var episode: Episode { controller.episode }

    public var body: some View {
        VStack(spacing: 20) {
            Text(episode.title)
                .font(.largeTitle)
            Text(episode.description)
                .font(.subheadline)
                .padding(.bottom, 20)
            episodeActions
        }
        .padding()
        .navigationTitle("#\(episode.episodeNumber)")
        .navigationBarTitleDisplayMode(.inline)
    }

    @MainActor
    var episodeActions: some View {
        HStack {
            Button(controller.favoritesButtonTitle) {
                Task {
                    await controller.toggleFavorite()
                }
            }
        }
    }
}

struct EpisodeDetail_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            EpisodeDetail(
                controller: .init(
                    episode: .sample,
                    store: Store.favorites)
            )
        }
    }
}
