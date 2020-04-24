//  PlayerButton.swift - WCRB

import Foundation
import UIKit

class PlayerButton: UIView {
    var title: String? {
        didSet {
            self.button.setTitle(title, for: .normal)
        }
    }
    
    var image: UIImage? {
        didSet {
            self.button.setImage(image, for: .normal)
        }
    }
    
    var onPress: (() -> Void)?
    
    private var button: UIButton!
    
    init() {
        super.init(frame: .zero)
        
        self.backgroundColor = .secondarySystemGroupedBackground
        self.layer.cornerRadius = 12
        self.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        self.button = UIButton(type: .system)
        self.button.imageView!.contentMode = .scaleAspectFit
        self.button.titleLabel!.font = .systemFont(ofSize: 17, weight: .bold)
        self.button.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)
        self.addSubview(self.button)
        self.button.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(-3)
            make.centerY.equalToSuperview()
        }
        
        self.button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: -6)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func buttonTapped() {
        self.onPress?()
    }
}
