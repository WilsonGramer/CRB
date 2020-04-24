//  InfoButtonsView.swift - WCRB

import Foundation
import UIKit

class InfoButtonsView: UIView {
    var onPressSearchButton: (() -> Void)? {
        didSet {
            self.searchButton.onPress = self.onPressSearchButton
        }
    }
    
    var onPressiTunesButton: (() -> Void)? {
        didSet {
            self.iTunesButton.onPress = self.onPressiTunesButton
        }
    }
    
    var onPressArkivMusicButton: (() -> Void)? {
        didSet {
            self.arkivMusicButton.onPress = self.onPressArkivMusicButton
        }
    }
    
    private var buttonContainer: UIStackView!
    private var searchButton: InfoButtonCell!
    private var iTunesButton: InfoButtonCell!
    private var arkivMusicButton: InfoButtonCell!
    
    init() {
        super.init(frame: .zero)
        
        self.buttonContainer = UIStackView()
        self.buttonContainer.axis = .vertical
        self.buttonContainer.spacing = 16
        self.addSubview(self.buttonContainer)
        self.buttonContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.searchButton = InfoButtonCell()
        self.searchButton.label = "Search on the Web"
        self.buttonContainer.addArrangedSubview(self.searchButton)
        
        self.iTunesButton = InfoButtonCell()
        self.iTunesButton.label = "View on iTunes"
        self.buttonContainer.addArrangedSubview(self.iTunesButton)
        
        self.arkivMusicButton = InfoButtonCell()
        self.arkivMusicButton.label = "View on ArkivMusic"
        self.buttonContainer.addArrangedSubview(self.arkivMusicButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
