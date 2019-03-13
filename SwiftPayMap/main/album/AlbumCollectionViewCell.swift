//
//  AlbumCollectionViewCell.swift
//  SwiftPayMap
//
//  Created by KyungSeok Lee on 2019. 3. 12..
//  Copyright © 2019년 KyungSeok Lee. All rights reserved.
//

import UIKit
import Hero

class AlbumCollectionViewCell: UICollectionViewCell {
    
    let mainImageView = UIImageView().then{
        $0.contentMode = ContentMode.scaleAspectFit
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        uiSetting()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mainImageView.image = nil
    }
    
    
    private func uiSetting(){
        [mainImageView].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview($0)
        }
        mainImageView.snp.makeConstraints{
            $0.edges.equalTo(self.contentView)
        }
    }
}
