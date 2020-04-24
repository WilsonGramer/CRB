//  MoreInfoView.swift - WCRB

import Foundation
import UIKit

class MoreInfoView: UIView {
    var info: [(name: String, value: String)]? {
        didSet {
            self.rebuildCells()
        }
    }
    
    private var titleLabel: UILabel!
    private var cellContainer: UIStackView!
    
    init() {
        super.init(frame: .zero)
        
        self.titleLabel = UILabel()
        self.titleLabel.text = "More Info"
        self.titleLabel.font = .systemFont(ofSize: 28, weight: .heavy)
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        
        self.cellContainer = UIStackView()
        self.cellContainer.axis = .vertical
        self.cellContainer.spacing = 16
        self.addSubview(self.cellContainer)
        self.cellContainer.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(24)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func rebuildCells() {
        for subview in self.cellContainer.arrangedSubviews {
            self.cellContainer.removeArrangedSubview(subview)
        }
        
        for infoItem in self.info ?? [] {
            let cell = MoreInfoCell()
            cell.name = infoItem.name
            cell.value = infoItem.value
            self.cellContainer.addArrangedSubview(cell)
        }
    }
}
