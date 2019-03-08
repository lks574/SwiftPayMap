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
 
    let bubbleView = UIView(frame: .zero).then{
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray.cgColor
        $0.layer.cornerRadius = 10
    }
    
    let mainImageView = UIImageView(frame: .zero).then{
        $0.contentMode = ContentMode.scaleAspectFit
    }
    
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
        mainImageView.image = nil
    }
    
    
    private func uiSetting(){
        [bubbleView].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview($0)
        }
        [mainImageView, myMessage].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            bubbleView.addSubview($0)
        }
        bubbleView.snp.makeConstraints{
            $0.top.equalTo(self.contentView)
            $0.leading.equalTo(self.contentView).offset(10)
            $0.trailing.equalTo(self.contentView).multipliedBy(0.7)
            $0.bottom.equalTo(self.contentView).offset(-10)
        }
        
        mainImageView.snp.makeConstraints{
            $0.top.equalTo(bubbleView).offset(10)
            $0.leading.equalTo(bubbleView).offset(10)
            $0.trailing.equalTo(bubbleView).offset(-10)
        }
        myMessage.snp.makeConstraints{
            $0.top.equalTo(mainImageView.snp.bottom).offset(10)
            $0.leading.equalTo(bubbleView).offset(10)
            $0.trailing.equalTo(bubbleView).offset(-10)
            $0.bottom.equalTo(bubbleView).offset(-10)
        }
    }

}

