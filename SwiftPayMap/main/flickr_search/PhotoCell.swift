//
//  PhotoCell.swift
//  SwiftPayMap
//
//  Created by KyungSeok Lee on 2019. 3. 6..
//  Copyright © 2019년 KyungSeok Lee. All rights reserved.
//

import UIKit
import SnapKit
import Then

class PhotoCell: UICollectionViewCell {
    let flickrPhoto = UIImageView(frame: .zero).then{
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(self.flickrPhoto)
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.flickrPhoto.image = nil
    }
    
    func setupConstraints(){
        self.flickrPhoto.snp.makeConstraints{
            $0.edges.equalTo(self.contentView)
        }
    }
}
