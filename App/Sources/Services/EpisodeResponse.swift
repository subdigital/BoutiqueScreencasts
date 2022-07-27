import Foundation

public struct EpisodeResponse: Codable, Identifiable, Equatable {
    public let id: Int
    public let title: String
    public let episodeNumber: Int
    public let description: String
}
