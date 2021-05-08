import SwiftUI

struct MusicPlayerView: View {
    @EnvironmentObject var musicPlayer: MusicPlayer
    
    @ScaledMetric(relativeTo: .largeTitle) var trackNameFontSize: CGFloat = 60
    @ScaledMetric(relativeTo: .title) var largeIconSize: CGFloat = 84
    @ScaledMetric var smallIconSize: CGFloat = 48
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RadialGradient(
                    gradient: Gradient(colors: [.blue, .blue.opacity(0.25)]),
                    center: UnitPoint(x: 0.35, y: 0.25),
                    startRadius: 0,
                    endRadius: max(geometry.size.width, geometry.size.height)
                )
                .opacity(self.musicPlayer.isPlaying ? 1 : 0.4)
                .background(Color.black)
                .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 10) {
                    Group {
                        HStack(alignment: .firstTextBaseline) {
                            NowPlayingIndicator(state: self.musicPlayer.isPlaying ? .play : .pause)
                                .frame(width: 20, height: 16)
                            
                            Text("Now Playing on CRB")
                                .font(.body.weight(.bold).smallCaps())
                                .kerning(1.4)
                        }
                        .opacity(0.75)
                        
                        Group {
                            if let track = self.musicPlayer.track {
                                if let name = track.name, let artist = track.artist {
                                    Text(name)
                                        + Text(" ")
                                        + Text(artist).foregroundColor(.white.opacity(0.5))
                                } else if let name = track.name {
                                    Text(name)
                                } else {
                                    Text("Intermission")
                                        .foregroundColor(.white.opacity(0.5))
                                }
                            } else {
                                Text("Loading")
                                    .foregroundColor(.white.opacity(0.5))
                            }
                        }
                        .font(.system(size: self.trackNameFontSize))
                    }
                    .foregroundColor(.white)
                    
                    Spacer()
                    
                    HStack {
                        CircleButton(action: {
                            MusicPlayer.shared.showAirPlayMenu()
                        }) {
                            Image(systemName: "airplayaudio")
                                .resizable()
                                .scaledToFit()
                        }
                        .frame(width: self.smallIconSize, height: self.smallIconSize)
                        
                        Spacer()
                        
                        CircleButton(action: {
                            withAnimation {
                                self.musicPlayer.isPlaying.toggle()
                            }
                        }) {
                            if self.musicPlayer.isPlaying {
                                Image(systemName: "stop.fill")
                                    .resizable()
                                    .scaledToFit()
                            } else {
                                Image(systemName: "play.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .padding(.leading, self.smallIconSize * 0.1)
                            }
                        }
                        .frame(width: self.largeIconSize, height: self.largeIconSize)
                        
                        Spacer()
                        
                        CircleButton(action: {
                            UIApplication.shared.open(Config.webURL)
                        }) {
                            Image(systemName: "safari")
                                .resizable()
                                .scaledToFit()
                        }
                        .frame(width: self.smallIconSize, height: self.smallIconSize)
                    }
                    .padding(.horizontal)
                }
                .padding(32)
            }
        }
        .onAppear {
            withAnimation {
                self.musicPlayer.isPlaying = true
            }
        }
    }
}

#if DEBUG
struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        MusicPlayerView()
            .environmentObject(MusicPlayer.shared)
    }
}
#endif
