//  StreamPlayer.swift - WCRB

import Foundation
import AVFoundation
import MediaPlayer

extension Notification.Name {
    static let StreamPlayerStatusUpdated = NSNotification.Name("StreamPlayerStatusUpdated")
}

enum StreamPlayer {
    private static var playerItem: AVPlayerItem!
    private static var player: AVPlayer!
    
    static var isPlaying = false
    
    static func setupPlayer(url: URL) throws {
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.playback)
        try audioSession.setActive(true)
        
        self.playerItem = AVPlayerItem(url: url)
        self.player = AVPlayer(playerItem: self.playerItem)
        
        let nowPlaying = MPNowPlayingInfoCenter.default()
        FetchMetadata.onUpdate { metadata in
            nowPlaying.nowPlayingInfo = [
                MPNowPlayingInfoPropertyAssetURL: url,
                MPNowPlayingInfoPropertyIsLiveStream: true,
                MPMediaItemPropertyTitle: metadata.onNow.song?.trackName as Any,
                MPMediaItemPropertyAlbumTitle: metadata.onNow.program.name,
                MPMediaItemPropertyArtwork: MPMediaItemArtwork(
                    boundsSize: CGSize(
                        width: CGFloat.greatestFiniteMagnitude,
                        height: CGFloat.greatestFiniteMagnitude
                    ),
                    requestHandler: { _ in
                        UIImage(named: "WCRB Logo")!
                    }
                ),
            ]
        }
        
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.togglePlayPauseCommand.isEnabled = true
        commandCenter.togglePlayPauseCommand.addTarget { event in
            if self.isPlaying {
                self.stop()
            } else {
                self.play()
            }
            
            NotificationCenter.default.post(Notification(name: .StreamPlayerStatusUpdated))
            
            return .success
        }
        
        UIApplication.shared.beginReceivingRemoteControlEvents()
    }
    
    static func play() {
        // Reset the stream so it goes back to live
        self.player.replaceCurrentItem(with: nil)
        self.player.replaceCurrentItem(with: self.playerItem)
        
        self.player.play()
        self.isPlaying = true
    }
    
    static func stop() {
        self.player.pause()
        self.isPlaying = false
    }
}

extension StreamPlayer {
    static let wcrbStreamURL = URL(string: "https://streams.audio.wgbh.org:8204/classical-hi")!
}
