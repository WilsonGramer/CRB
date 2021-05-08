import Foundation

struct Track: Hashable {
    let name: String?
    let artist: String?
}

extension Track {
    init(metadata: Metadata) {
        if let song = metadata.onNow?.song {
            self.name = song.trackName
            self.artist = song.composerName ?? song.collectionName ?? song.artistName ?? song.conductorName
        } else {
            self.name = nil
            self.artist = nil
        }
    }
}
