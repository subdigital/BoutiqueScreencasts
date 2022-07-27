import Foundation
import SwiftUI

public struct UserFavorites: Codable, Identifiable, Equatable {
    public var id: String { "user_favorites" } // essentially means only 1 ever stored
    public var episodeIDs: Set<Int> = []

    public init() {
    }
}
