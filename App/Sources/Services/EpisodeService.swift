import Foundation
import Models

public protocol EpisodeService {
    func fetchEpisodes() async throws -> [Episode]
}

public struct LiveEpisodeService: EpisodeService {
    private let baseURL = URL(string: "https://nsscreencast.com/api/")!
    private let decoder = {
        let d = JSONDecoder()
        d.dateDecodingStrategy = .iso8601
        d.keyDecodingStrategy = .convertFromSnakeCase
        return d
    }()

    public func fetchEpisodes() async throws -> [Episode] {
        let url = baseURL.appendingPathComponent("episodes")
        let (data, _) = try await URLSession.shared.data(from: url)
        struct EpisodesWrappper: Codable {
            let episodes: [Episode]
        }
        let result = try decoder.decode(EpisodesWrappper.self, from: data)
        return result.episodes
    }
}

public extension EpisodeService where Self == LiveEpisodeService {
    static func live() -> Self {
        LiveEpisodeService()
    }
}
