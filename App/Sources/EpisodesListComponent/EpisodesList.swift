import SwiftUI
import Stores
import Boutique
import Models

public struct EpisodesList: View {
    @ObservedObject var controller: EpisodesController

    public init(controller: EpisodesController) {
        self.controller = controller
    }

    public var body: some View {
        List(controller.sortedEpisodes) { episode in
            NavigationLink(destination: makeDestination(episode)) {
                HStack {
                    artwork(for: episode)

                    VStack(alignment: .leading, spacing: 3) {
                        Text(episode.title)
                            .font(.headline)
                        Text("#\(episode.episodeNumber)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)

                    Spacer()
                    if controller.isFavorite(episode: episode) {
                        Image(systemName: "star.fill")
                    }
                }
            }
            .listRowInsets(.init(top: 12, leading: 8, bottom: 12, trailing: 16))
        }
        .listStyle(PlainListStyle())
    }

    private func artwork(for episode: Episode) -> some View {
        AsyncImage(url: episode.mediumArtworkUrl) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
        } placeholder: {
            Rectangle()
                .fill(Color.secondary)
        }
        .frame(width: 80, height: 50)
        .cornerRadius(4)
    }

    private func makeDestination(_ episode: Episode) -> some View {
        EpisodeDetail(controller: controller.detailController(for: episode))
    }
}

struct EpisodesList_Previews: PreviewProvider {
    static var previews: some View {
        let controller = EpisodesController(store: .episodes, favorites: .favorites)
        return EpisodesList(controller: controller)
            .task {
                await controller.fetchEpisodes()
            }
    }
}
