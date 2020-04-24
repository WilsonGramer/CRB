//  InfoButtonCell.swift - WCRB

import Foundation
import UIKit

class InfoButtonCell: UIView {
    var label: String? {
        didSet {
            self.button.setTitle(self.label, for: .normal)
        }
    }
    
    var onPress: (() -> Void)?
    
    private var button: UIButton!
    
    init() {
        super.init(frame: .zero)
        
        self.backgroundColor = .secondarySystemGroupedBackground
        self.layer.cornerRadius = 12
        
        self.button = UIButton(type: .system)
        self.button.titleLabel!.font = .systemFont(ofSize: 17, weight: .heavy)
        self.button.titleLabel!.numberOfLines = 0
        self.button.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)
        self.addSubview(self.button)
        self.button.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(12)
            make.left.equalToSuperview().inset(18)
            make.right.lessThanOrEqualToSuperview().inset(18)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func buttonTapped() {
        self.onPress?()
    }
}
