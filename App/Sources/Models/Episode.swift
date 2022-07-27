import Foundation

public struct Episode: Codable, Identifiable, Equatable {
    public let id: Int
    public let title: String
    public let episodeNumber: Int
    public let description: String
    public let mediumArtworkUrl: URL?
    public let largeArtworkUrl: URL?
}

extension Episode: Comparable {
    public static func < (lhs: Episode, rhs: Episode) -> Bool {
        lhs.episodeNumber < rhs.episodeNumber
    }
}
