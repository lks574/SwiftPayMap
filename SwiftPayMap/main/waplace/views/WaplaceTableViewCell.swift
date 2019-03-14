//
//  WaplaceTableViewCell.swift
//  SwiftPayMap
//
//  Created by KyungSeok Lee on 2019. 3. 14..
//  Copyright © 2019년 KyungSeok Lee. All rights reserved.
//

import Foundation
import Then
import SnapKit

class WaplaceTableViewCell: UITableViewCell {
    
    let mainLabel = UILabel().then{
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.textColor = UIColor(rgb: 0x4a4a4a)
    }
    let arrowImageView = UIImageView().then{
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "arrow-right-small")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        uiSetting()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    
    private func uiSetting(){
        [mainLabel, arrowImageView].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview($0)
        }
        mainLabel.snp.makeConstraints{
            $0.top.equalTo(self.contentView).offset(12)
            $0.leading.equalTo(self.contentView).offset(12)
            $0.bottom.equalTo(self.contentView).offset(-12)
        }
        arrowImageView.snp.makeConstraints{
            $0.centerY.equalTo(mainLabel)
            $0.trailing.equalTo(self.contentView).offset(-12)
        }
    }
}
