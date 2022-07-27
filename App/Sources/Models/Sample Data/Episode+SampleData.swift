#if DEBUG

public extension Episode {
    static var sample: Episode {
        .init(
            id: 123,
            title: "Doing stuff with Swift",
            episodeNumber: 233,
            description:
                """
                In this episode we do all kinds of cool stuff with Swift. We start by declaring
                some variables, then calls some functions. We then compile and stuff.
                """,
            mediumArtworkUrl: nil,
            largeArtworkUrl: nil
        )
    }
}

#endif
