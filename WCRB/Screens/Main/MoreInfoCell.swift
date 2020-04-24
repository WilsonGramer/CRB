//  MoreInfoCell.swift - WCRB

import Foundation
import UIKit

class MoreInfoCell: UIView {
    var name: String? {
        didSet {
            self.nameLabel.text = self.name
        }
    }
    
    var value: String? {
        didSet {
            self.valueLabel.text = self.value
        }
    }
    
    private var nameLabel: UILabel!
    private var valueLabel: UILabel!
    
    init() {
        super.init(frame: .zero)
        
        self.backgroundColor = .secondarySystemGroupedBackground
        self.layer.cornerRadius = 12
        
        self.nameLabel = UILabel()
        self.nameLabel.font = .systemFont(ofSize: 17, weight: .heavy)
        self.nameLabel.numberOfLines = 0
        self.addSubview(self.nameLabel)
        self.nameLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(18)
        }
        
        self.valueLabel = UILabel()
        self.valueLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        self.valueLabel.textColor = .secondaryLabel
        self.valueLabel.numberOfLines = 0
        self.addSubview(self.valueLabel)
        self.valueLabel.snp.makeConstraints { make in
            make.top.equalTo(self.nameLabel.snp.bottom).offset(8)
            make.left.right.bottom.equalToSuperview().inset(18)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
