//  MainScreenVC.swift - WCRB

import Foundation
import UIKit
import SnapKit
import SafariServices

// MARK: - Layout

class MainScreenVC: UIViewController {
    private var scrollView: UIScrollView!
    private var scrollViewContent: UIView!
    private var playerView: PlayerView!
    private var playerButtonsContainer: UIStackView!
    private var viewOnlineButton: PlayerButton!
    private var shareButton: PlayerButton!
    private var moreInfoView: MoreInfoView!
    private var infoButtonsView: InfoButtonsView!
    private var statusBarOverlay: UIView!
    
    private var alreadyAppeared = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemGroupedBackground
        
        self.scrollView = UIScrollView()
        self.scrollView.alwaysBounceVertical = true
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.contentInset.bottom = 12
        self.view.addSubview(self.scrollView)
        self.scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.scrollViewContent = UIView()
        self.scrollView.addSubview(self.scrollViewContent)
        self.scrollViewContent.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(self.view)
        }
        
        self.playerView = PlayerView()
        self.playerView.coverImage = UIImage(named: "WCRB Logo")
        self.playerView.onPressPlayButton = self.playButtonPressed
        self.scrollViewContent.addSubview(self.playerView)
        self.playerView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(24)
        }
        
        self.playerButtonsContainer = UIStackView()
        self.playerButtonsContainer.axis = .horizontal
        self.playerButtonsContainer.alignment = .fill
        self.playerButtonsContainer.distribution = .fillEqually
        self.playerButtonsContainer.spacing = 12
        self.scrollViewContent.addSubview(self.playerButtonsContainer)
        self.playerButtonsContainer.snp.makeConstraints { make in
            make.top.equalTo(self.playerView.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(24)
        }
        
        self.viewOnlineButton = PlayerButton()
        self.viewOnlineButton.title = "View Online"
        self.viewOnlineButton.image = UIImage(systemName: "music.note.list")
        self.viewOnlineButton.onPress = self.viewOnlineButtonPressed
        self.playerButtonsContainer.addArrangedSubview(self.viewOnlineButton)
        
        self.shareButton = PlayerButton()
        self.shareButton.title = "Share"
        self.shareButton.image = UIImage(systemName: "square.and.arrow.up")
        self.shareButton.onPress = self.shareButtonPressed
        self.playerButtonsContainer.addArrangedSubview(self.shareButton)
        
        self.moreInfoView = MoreInfoView()
        self.scrollViewContent.addSubview(self.moreInfoView)
        self.moreInfoView.snp.makeConstraints { make in
            make.top.equalTo(self.playerButtonsContainer.snp.bottom).offset(34)
            make.left.right.equalToSuperview().inset(24)
        }
        
        self.infoButtonsView = InfoButtonsView()
        self.infoButtonsView.onPressSearchButton = self.searchButtonPressed
        self.infoButtonsView.onPressiTunesButton = self.iTunesButtonPressed
        self.infoButtonsView.onPressArkivMusicButton = self.arkivMusicButtonPressed
        self.scrollViewContent.addSubview(self.infoButtonsView)
        self.infoButtonsView.snp.makeConstraints { make in
            make.top.equalTo(self.moreInfoView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(24)
            make.bottom.equalToSuperview()
        }
        
        self.statusBarOverlay = UIView()
        self.statusBarOverlay.backgroundColor = self.view.backgroundColor
        self.view.addSubview(self.statusBarOverlay)
        self.statusBarOverlay.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(UIApplication.shared.statusBarFrame.height)
        }
    }
}

// MARK: - Subscribe to metadata & player updates

extension MainScreenVC {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard !self.alreadyAppeared else { return }
        self.alreadyAppeared = true

        // TODO: Error handling
        try! StreamPlayer.setupPlayer(url: StreamPlayer.wcrbStreamURL)
        
        NotificationCenter.default.addObserver(forName: .StreamPlayerStatusUpdated, object: nil, queue: nil) { [weak self] _ in
            self?.streamPlayerStatusUpdated()
        }
        
        FetchMetadata.startListening()
        
        FetchMetadata.onUpdate { [weak self] metadata in
            self?.updateMetadata(metadata)
        }
    }
    
    private func updateMetadata(_ metadata: Metadata) {
        self.playerView.title = metadata.onNow.song?.trackName
        
        func info(_ name: String, _ property: String?) -> (name: String, value: String)? {
            property?.nilIfEmpty.map {
                (name: name, value: $0)
            }
        }
        
        self.moreInfoView.info = [
            info("Title", metadata.onNow.song?.trackName),
            info("Composer", metadata.onNow.song?.composerName),
            info("Conductor", metadata.onNow.song?.conductor),
            info("Artist", metadata.onNow.song?.artistName),
            info("Duration", (metadata.onNow.song?.duration).map(TimeInterval.init)?.minuteSecondFormat()),
            info("Instruments", metadata.onNow.song?.instruments),
            info("Soloists", metadata.onNow.song?.soloists),
            info("Ensembles", metadata.onNow.song?.ensembles),
            info("Collection", metadata.onNow.song?.collectionName),
            info("Program", metadata.onNow.program.name),
        ].compactMap { $0 }
        
        self.view.setNeedsLayout()
        self.view.setNeedsDisplay()
    }
    
    private func streamPlayerStatusUpdated() {
        self.playerView.playButtonState = StreamPlayer.isPlaying ? .playing : .stopped
    }
}

// MARK: - Button handlers

private extension MainScreenVC {
    func playButtonPressed(_ playButtonState: PlayerView.PlayButtonState) {
        switch playButtonState {
        case .playing:
            StreamPlayer.play()
        case .stopped:
            StreamPlayer.stop()
        }
    }
    
    func viewOnlineButtonPressed() {
        self.openURL("https://www.classicalwcrb.org/")
    }
    
    func shareButtonPressed() {
        guard let metadata = FetchMetadata.metadata else { return }

        let shareSheet = UIActivityViewController(activityItems: [
            metadata.onNow.song
                .map { "\($0.trackName) \($0.composerName)" } as Any,
            
            URL(string: "https://classicalwcrb.org/")!,
        ], applicationActivities: nil)
        
        self.present(shareSheet, animated: true)
    }
    
    func searchButtonPressed() {
        guard let metadata = FetchMetadata.metadata else { return }
        
        self.openURL("https://www.google.com/search?q=\(metadata.onNow.song?.trackName ?? "") \(metadata.onNow.song?.composerName ?? "")")
    }
    
    func iTunesButtonPressed() {
        guard
            let metadata = FetchMetadata.metadata,
            let song = metadata.onNow.song,
            let iTunesURL = song.buy.itunes.nilIfEmpty
        else { return }
        
        self.openURL(iTunesURL)
    }
    
    func arkivMusicButtonPressed() {
        guard
            let metadata = FetchMetadata.metadata,
            let song = metadata.onNow.song,
            let arkivMusicURL = song.buy.arkiv.nilIfEmpty
        else { return }
        
        self.openURL(arkivMusicURL)
    }
}

private extension MainScreenVC {
    func openURL(_ url: String) {
        let encodedURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let vc = SFSafariViewController(url: URL(string: encodedURL)!)
        self.present(vc, animated: true)
    }
}
