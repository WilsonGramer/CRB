//  FetchMetadata.swift - WCRB

import Foundation

enum FetchMetadata {
    private static var listeners: [(Metadata) -> Void] = []
    
    private static var previousMetadata: Metadata?
    static var metadata: Metadata?
    
    static func onUpdate(_ listener: @escaping (Metadata) -> Void) {
        self.listeners.append(listener)
    }
    
    static func startListening() {
        let timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
            self.fetch { metadata in
                guard
                    let metadata = metadata,
                    metadata != self.previousMetadata
                else { return }
                
                DispatchQueue.main.async {
                    for listener in self.listeners {
                        listener(metadata)
                    }
                }
            }
        }
        
        timer.fire()
    }
}

extension FetchMetadata {
    private static let metadataURL = URL(string: "https://api.composer.nprstations.org/v1/widget/53877c98e1c80a130decb6c8/now?format=json")!
    
    private static func fetch(completion: @escaping (Metadata?) -> Void) {
        URLSession.shared.dataTask(with: self.metadataURL) { data, response, error in
            let metadata = data.flatMap {
                try? JSONDecoder().decode(Metadata.self, from: $0)
            }
            
            self.previousMetadata = self.metadata
            self.metadata = metadata
            
            completion(metadata)
        }.resume()
    }
}
