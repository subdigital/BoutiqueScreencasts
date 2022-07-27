import Boutique
import Bodega
import Foundation
import Models

extension Episode {
    var cacheIdentifier: String {
        String(id)
    }
}

public extension Store where Item == Episode {
    static var episodes: Store<Episode> {
        .init(
            storagePath: FileManager.Directory.caches(appendingPath: "episodes").url,
            cacheIdentifier: \.cacheIdentifier
        )
    }
}
