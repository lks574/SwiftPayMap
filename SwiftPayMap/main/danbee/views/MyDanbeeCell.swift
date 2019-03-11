//
//  MyDanbeeCell.swift
//  SwiftPayMap
//
//  Created by KyungSeok Lee on 2019. 3. 8..
//  Copyright © 2019년 KyungSeok Lee. All rights reserved.
//

import UIKit
import SnapKit
import Then


class MyDanbeeCell: UITableViewCell {
 
    let borderView = UIView().then {
        $0.layer.borderColor = UIColor.blue.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 10
    }
    
    let messageLabel = UILabel().then{
        $0.textColor = UIColor.black
        $0.font = UIFont.systemFont(ofSize: 15)
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        uiSetting()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        messageLabel.text = ""
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func uiSetting(){
        [borderView].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview($0)
        }
        [messageLabel].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            borderView.addSubview($0)
        }
        borderView.snp.makeConstraints{
            $0.top.equalTo(self.contentView).offset(5)
            $0.trailing.equalTo(self.contentView).offset(-5)
            $0.width.equalTo(self.contentView).multipliedBy(0.7)
            $0.bottom.equalTo(self.contentView).offset(-5)
        }
        messageLabel.snp.makeConstraints{
            $0.top.equalTo(borderView).offset(5)
            $0.leading.equalTo(borderView).offset(5)
            $0.trailing.equalTo(borderView).offset(-5)
            $0.bottom.equalTo(borderView).offset(-5)
        }
    }

}

