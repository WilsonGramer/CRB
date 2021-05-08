import Foundation
import SwiftCoroutine

func fetchMetadata() throws -> Metadata {
    let response = try URLSession.shared.dataTaskFuture(for: Config.metadataURL).await()
    let content = try JSONDecoder().decode(Metadata.self, from: response.data)
    return content
}

private var timer: Timer?

func fetchMetadataPeriodically(onUpdate: @escaping (Metadata) -> Void) {
    timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { timer in        
        DispatchQueue.main.startCoroutine {
            do {
                let metadata = try fetchMetadata()
                onUpdate(metadata)
            } catch {
                print("Error fetching metadata:", error)
            }
        }
    }
    
    timer!.fire()
}

func stopFetchingMetadataPeriodically() {
    timer!.invalidate()
    timer = nil
}
