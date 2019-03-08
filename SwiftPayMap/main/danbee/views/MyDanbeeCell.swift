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
    
    let myMessage = UILabel().then{
        $0.textColor = UIColor.black
        $0.numberOfLines = 0
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = UIColor.white
        uiSetting()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.myMessage.text = ""
    }
    
    
    private func uiSetting(){
        [myMessage].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview($0)
        }
        myMessage.snp.makeConstraints{
            $0.top.equalTo(self.contentView.snp.top).offset(10)
            $0.leading.equalTo(self.contentView.snp.leading).offset(10)
            $0.trailing.equalTo(self.contentView.snp.trailing).offset(-10)
            $0.bottom.equalTo(self.contentView.snp.bottom).offset(-10)
        }
    }

}

