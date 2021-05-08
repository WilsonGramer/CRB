import Foundation
import SwiftUI
import AVKit
import MediaPlayer

class MusicPlayer: ObservableObject {
    static let shared = MusicPlayer()
    
    private lazy var player: AVPlayer = {
        let player = AVPlayer(url: Config.streamURL)
        player.automaticallyWaitsToMinimizeStalling = true
        return player
    }()
    
    private var playHandler: Any?
    private var stopHandler: Any?
    private var toggleHandler: Any?
    
    @Published var isPlaying = false {
        didSet {
            if self.isPlaying {
                self.play()
            } else {
                self.stop()
            }
        }
    }
    
    @Published var track: Track? {
        didSet {
            if let track = self.track {
                self.updateNowPlayingInfo(with: track)
            } else {
                self.clearNowPlayingInfo()
            }
        }
    }
}

// MARK: - Play stream

extension MusicPlayer {
    func play() {
        self.player.play()
        
        try? AVAudioSession.sharedInstance().setCategory(.playback)
        
        if let livePosition = self.player.currentItem?.seekableTimeRanges.last as? CMTimeRange {
            self.player.seek(to: livePosition.end)
        }
    }
    
    func stop() {
        self.player.pause()
    }
}

// MARK: - Now Playing info

extension MusicPlayer {
    func updateNowPlayingInfo(with track: Track) {
        MPRemoteCommandCenter.shared().playCommand.isEnabled = true
        self.playHandler = MPRemoteCommandCenter.shared().playCommand.addTarget { event in
            withAnimation {
                self.isPlaying = true
            }
            
            return .success
        }
        
        MPRemoteCommandCenter.shared().stopCommand.isEnabled = true
        self.stopHandler = MPRemoteCommandCenter.shared().stopCommand.addTarget { event in
            withAnimation {
                self.isPlaying = false
            }
            
            return .success
        }
        
        MPRemoteCommandCenter.shared().togglePlayPauseCommand.isEnabled = true
        self.toggleHandler = MPRemoteCommandCenter.shared().togglePlayPauseCommand.addTarget { event in
            withAnimation {
                self.isPlaying.toggle()
            }
            
            return .success
        }


        MPNowPlayingInfoCenter.default().nowPlayingInfo = [
            MPMediaItemPropertyTitle: track.name as Any,
            MPMediaItemPropertyArtist: track.artist as Any,
            MPNowPlayingInfoPropertyIsLiveStream: true,
        ]
    }
    
    func clearNowPlayingInfo() {
        MPRemoteCommandCenter.shared().playCommand.isEnabled = false
        self.playHandler = nil
        
        MPRemoteCommandCenter.shared().stopCommand.isEnabled = false
        self.stopHandler = nil
        
        MPRemoteCommandCenter.shared().togglePlayPauseCommand.isEnabled = false
        self.toggleHandler = nil
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [:]
    }
}

// MARK: - Remote control

extension MusicPlayer {
    func handle(_ event: UIEvent) {
        withAnimation {
            switch event.subtype {
            case .remoteControlPlay:
                self.isPlaying = true
            case .remoteControlPause, .remoteControlStop:
                self.isPlaying = false
            case .remoteControlTogglePlayPause:
                self.isPlaying.toggle()
            default:
                break
            }
        }
    }
}

// MARK: - Show AirPlay menu

extension MusicPlayer {
    func showAirPlayMenu() {
        let routePicker = AVRoutePickerView()
        routePicker.isHidden = true
        
        UIApplication.shared.windows.first(where: \.isKeyWindow)!.addSubview(routePicker)
        
        DispatchQueue.main.async {
            guard let button = routePicker.subviews.lazy.compactMap({ $0 as? UIButton }).first else {
                return
            }
            
            button.sendActions(for: .touchUpInside)
            
            DispatchQueue.main.async {
                routePicker.removeFromSuperview()
            }
        }
    }
}
