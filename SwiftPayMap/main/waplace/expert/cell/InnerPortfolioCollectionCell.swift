//
//  InnerPortfolioCollectionCell.swift
//  SwiftPayMap
//
//  Created by KyungSeok Lee on 2019. 3. 15..
//  Copyright © 2019년 KyungSeok Lee. All rights reserved.
//

import Foundation
import RxDataSources


class InnerPortfolioCollectionCell: UICollectionViewCell {
    
    let mainImageView = UIImageView()
    let titleLabel = UILabel().then{
        $0.textColor = UIColor(rgb: 0x4a4a4a)
        $0.font = UIFont.systemFont(ofSize: 15, weight: .bold)
    }
    let detailLabel = UILabel().then{
        $0.textColor = UIColor(rgb: 0x777777)
        $0.font = UIFont.systemFont(ofSize: 12)
    }
    let categoryLabel = UILabel().then{
        $0.textColor = UIColor(rgb: 0xef6c00)
        $0.font = UIFont.systemFont(ofSize: 12)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        uiSetting()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func uiSetting(){
        self.contentView.layer.borderColor = UIColor.gray.cgColor
        self.contentView.layer.borderWidth = 1
        self.contentView.layer.cornerRadius = 5
        
        [mainImageView, titleLabel, detailLabel, categoryLabel].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview($0)
        }
        mainImageView.snp.makeConstraints{
            $0.top.equalTo(self.contentView)
            $0.leading.equalTo(self.contentView)
            $0.trailing.equalTo(self.contentView)
            $0.height.equalTo(self.contentView.snp.width).multipliedBy(0.7)
        }
        titleLabel.snp.makeConstraints{
            $0.top.equalTo(mainImageView.snp.bottom).offset(10)
            $0.leading.equalTo(mainImageView).offset(10)
            $0.trailing.equalTo(mainImageView).offset(-10)
        }
        detailLabel.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
            $0.leading.equalTo(titleLabel)
            $0.trailing.equalTo(titleLabel)
        }
        categoryLabel.snp.makeConstraints{
            $0.top.equalTo(detailLabel.snp.bottom).offset(5)
            $0.leading.equalTo(detailLabel)
            $0.trailing.equalTo(detailLabel)
            $0.bottom.equalTo(self.contentView).offset(-10)
        }
    }
}


/** Review탭 - View안의 tableViewCell SectionModel */
struct InnerPortfolioViewSectionModel {
    var model: [InnerPortfolioViewModel]
}

extension InnerPortfolioViewSectionModel: SectionModelType{
    var items: [InnerPortfolioViewModel] {
        return self.model
    }
    init(original: InnerPortfolioViewSectionModel, items: [InnerPortfolioViewModel]) {
        self = original
        self.model = items
    }
}

/** Review탭 - View안의 tableViewCell Cell의 모델 */
struct InnerPortfolioViewModel {
    let imageStr: String
    let title: String
    let company: String
    let category: String
    let like: String
    let views: String
    let comment: String
}
