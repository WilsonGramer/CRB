import SwiftUI

enum Config {
    static let streamURL = URL(string: Bundle.main.object(forInfoDictionaryKey: "STREAM_URL") as! String)!
    static let metadataURL = URL(string: Bundle.main.object(forInfoDictionaryKey: "METADATA_URL") as! String)!
    static let webURL = URL(string: "https://www.classicalwcrb.org")!
}

@main
struct App: SwiftUI.App {
    var body: some Scene {
        WindowGroup {
            MusicPlayerView()
                .environmentObject(MusicPlayer.shared)
                .handleRemoteControlEvents()
                .onAppear {
                    fetchMetadataPeriodically { metadata in
                        MusicPlayer.shared.track = Track(metadata: metadata)
                    }
                }
        }
    }
}
