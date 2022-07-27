import SwiftUI
import App
import EpisodesListComponent
import Stores
import Boutique

struct ContentView: View {
    @StateObject var appController = AppController()

    var body: some View {
        NavigationStack {
            EpisodesList(controller: appController.episodesController)
                .navigationTitle("Episodes")
        }
        .task {
            await appController.start()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
