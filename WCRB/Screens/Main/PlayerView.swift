//  PlayerView.swift - WCRB

import Foundation
import UIKit

class PlayerView: UIView {
    enum PlayButtonState {
        case playing
        case stopped
    }
    
    var title: String? {
        didSet {
            self.titleLabel.text = self.title
        }
    }
    
    var coverImage: UIImage? {
        didSet {
            self.coverImageView.image = self.coverImage
        }
    }
    
    var onPressPlayButton: ((PlayButtonState) -> Void)?
    
    private var coverImageViewContainer: UIView!
    private var coverImageView: UIImageView!
    private var titleLabel: UILabel!
    private var playButton: UIButton!
    
    var playButtonState: PlayButtonState = .stopped {
        didSet {
            self.updatePlayButtonImage()
        }
    }
    
    init() {
        super.init(frame: .zero)
        
        self.backgroundColor = .secondarySystemGroupedBackground
        self.layer.cornerRadius = 16
        
        self.coverImageViewContainer = UIView()
        self.coverImageViewContainer.layer.shadowColor = UIColor.darkText.cgColor
        self.coverImageViewContainer.layer.shadowOpacity = 0.35
        self.coverImageViewContainer.layer.shadowRadius = 20
        self.coverImageViewContainer.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.addSubview(self.coverImageViewContainer)
        self.coverImageViewContainer.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(38)
            make.width.equalTo(self.coverImageViewContainer.snp.height)
        }
        
        self.coverImageView = UIImageView()
        self.coverImageView.contentMode = .scaleAspectFill
        self.coverImageView.layer.masksToBounds = true
        self.coverImageView.layer.cornerRadius = 16
        self.coverImageViewContainer.addSubview(self.coverImageView)
        self.coverImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.titleLabel = UILabel()
        self.titleLabel.numberOfLines = 0
        self.titleLabel.font = .systemFont(ofSize: 24, weight: .heavy)
        self.titleLabel.textAlignment = .center
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.coverImageView.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(24)
        }
        
        self.playButton = UIButton(type: .system)
        self.updatePlayButtonImage()
        self.playButton.tintColor = .label
        self.playButton.imageView!.contentMode = .scaleAspectFit
        self.playButton.addTarget(self, action: #selector(self.playButtonTapped), for: .touchUpInside)
        self.addSubview(self.playButton)
        self.playButton.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(24)
            make.bottom.equalToSuperview().inset(38)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updatePlayButtonImage() {
        let imageName: String
        
        // Display the image opposite the state, to show what will happen if the
        // button is tapped again
        switch self.playButtonState {
        case .playing:
            imageName = "stop.fill"
        case .stopped:
            imageName = "play.fill"
        }
        
        self.playButton.setImage(
            UIImage(
                systemName: imageName,
                withConfiguration: UIImage.SymbolConfiguration(pointSize: 40, weight: .black)
            ),
            for: .normal
        )
    }
    
    @objc private func playButtonTapped() {
        switch self.playButtonState {
        case .playing: self.playButtonState = .stopped
        case .stopped: self.playButtonState = .playing
        }
        
        self.onPressPlayButton?(self.playButtonState)
    }
}
