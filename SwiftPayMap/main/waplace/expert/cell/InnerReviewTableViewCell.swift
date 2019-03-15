//
//  InnerReviewTableViewCell.swift
//  SwiftPayMap
//
//  Created by KyungSeok Lee on 2019. 3. 15..
//  Copyright © 2019년 KyungSeok Lee. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import RxOptional

/** Review탭 - View안의 tableViewCell */
class InnerReviewTableViewCell : UITableViewCell {
    
    let titleLabel = UILabel().then{
        $0.textColor = UIColor(rgb: 0x4a4a4a)
        $0.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        $0.numberOfLines = 0
    }
    let nameLabel = UILabel().then{
        $0.textColor = UIColor(rgb: 0x777777)
        $0.font = UIFont.systemFont(ofSize: 13)
    }
    let dateLabel = UILabel().then{
        $0.textColor = UIColor(rgb: 0x777777)
        $0.font = UIFont.systemFont(ofSize: 13)
    }
    let viewsLabel = UILabel().then{
        $0.textColor = UIColor(rgb: 0x777777)
        $0.font = UIFont.systemFont(ofSize: 13)
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
        [titleLabel, nameLabel, dateLabel, viewsLabel].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview($0)
        }
        titleLabel.snp.makeConstraints{
            $0.top.equalTo(self.contentView).offset(10)
            $0.leading.equalTo(self.contentView).offset(10)
        }
        nameLabel.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.equalTo(titleLabel)
            $0.bottom.equalTo(self.contentView).offset(-10)
        }
        dateLabel.snp.makeConstraints{
            $0.top.equalTo(nameLabel)
            $0.leading.equalTo(nameLabel.snp.trailing).offset(20)
        }
        viewsLabel.snp.makeConstraints{
            $0.top.equalTo(dateLabel)
            $0.leading.equalTo(dateLabel.snp.trailing).offset(20)
            $0.trailing.lessThanOrEqualTo(self.contentView).offset(-20)
        }
    }
}

/** Review탭 - View안의 tableViewCell SectionModel */
struct InnerReviewViewSectionModel {
    var model: [InnerReviewViewModel]
}

extension InnerReviewViewSectionModel: SectionModelType{
    var items: [InnerReviewViewModel] {
        return self.model
    }
    init(original: InnerReviewViewSectionModel, items: [InnerReviewViewModel]) {
        self = original
        self.model = items
    }
}

/** Review탭 - View안의 tableViewCell Cell의 모델 */
struct InnerReviewViewModel {
    let title: String
    let writeName: String
    let date: String
    let views: String
}



