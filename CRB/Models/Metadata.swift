import Foundation

struct Metadata: Hashable, Codable {
    let onNow: OnNow?
    
    struct OnNow: Hashable, Codable {
        let song: Song?
        
        struct Song: Hashable, Codable {
            let artistName: String?
            let collectionName: String?
            let composerName: String?
            let conductorName: String?
            let trackName: String?
        }
    }
}
