import Boutique
import Bodega
import Foundation
import Models

public extension Store where Item == UserFavorites {
    static var favorites: Store<UserFavorites> {
        .init(
            storagePath: FileManager.Directory.caches(appendingPath: "favorites").url,
            cacheIdentifier: \.id
        )
    }
}
