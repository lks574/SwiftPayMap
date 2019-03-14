//
//  WaplaceExpertTableViewCell.swift
//  SwiftPayMap
//
//  Created by KyungSeok Lee on 2019. 3. 14..
//  Copyright © 2019년 KyungSeok Lee. All rights reserved.
//

import Foundation
import Then
import SnapKit

class WaplaceExpertTableViewCell: UITableViewCell {
    
    var cellModel: WaplaceExpertModel? {
        didSet{
            guard let model = cellModel else { return }
            titleLabel.text = model.title
            mainImageView.image = UIImage(named: model.imageStr)
            buisnessLabel.text = model.buisnessType
            usageLabel.text = model.UsageType
            cidoLabel.text = model.cido
            explanationLabel.text = model.explanation
            carrerView.innerModel = ("경력", model.career)
            favoriteView.innerModel = ("찜", model.favorite)
            reviewView.innerModel = ("리뷰", model.review)
        }
    }
    
    let borderView = UIView().then{
        $0.layer.borderColor = UIColor(rgb: 0xcccccc).cgColor
        $0.layer.borderWidth = 1
    }
    let infoView = UIView()
    let titleLabel = UILabel().then{
        $0.textColor = UIColor(rgb: 0x4a4a4a)
        $0.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
    }
    let mainImageView = UIImageView().then{
        $0.contentMode = .scaleAspectFit
    }
    let buisnessLabel = UILabel().then{
        $0.textColor = UIColor(rgb: 0x4a4a4a)
        $0.font = UIFont.systemFont(ofSize: 14)
    }
    let usageLabel = UILabel().then{
        $0.textColor = UIColor(rgb: 0x4a4a4a)
        $0.font = UIFont.systemFont(ofSize: 14)
    }
    let cidoLabel = UILabel().then{
        $0.textColor = UIColor(rgb: 0x4a4a4a)
        $0.font = UIFont.systemFont(ofSize: 14)
    }
    let explanationLabel = UILabel().then{
        $0.textColor = UIColor(rgb: 0x4a4a4a)
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.numberOfLines = 0
    }
    let carrerView = WaplaceExpertInnerView()
    let favoriteView = WaplaceExpertInnerView()
    let reviewView = WaplaceExpertInnerView()
    
    let favoriteButton = UIButton().then{
        $0.setTitle("찜", for: .normal)
        $0.setTitleColor(UIColor(rgb: 0x4a4a4a), for: .normal)
    }
    let reviewButton = UIButton().then{
        $0.setTitle("리뷰작성", for: .normal)
        $0.setTitleColor(UIColor(rgb: 0x4a4a4a), for: .normal)
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
        [borderView].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview($0)
        }
        [mainImageView, infoView].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            borderView.addSubview($0)
        }
        borderView.snp.makeConstraints{
            $0.top.equalTo(self.contentView).offset(5)
            $0.leading.equalTo(self.contentView).offset(10)
            $0.trailing.equalTo(self.contentView).offset(-10)
            $0.bottom.equalTo(self.contentView).offset(-5)
        }
        infoView.snp.makeConstraints{
            $0.width.equalTo(borderView).multipliedBy(0.7)
            $0.top.equalTo(borderView).offset(5)
            $0.trailing.equalTo(borderView).offset(-5)
        }
        mainImageView.snp.makeConstraints{
            $0.height.equalTo(mainImageView.snp.width)
            $0.top.equalTo(infoView)
            $0.leading.equalTo(5)
            $0.trailing.equalTo(infoView.snp.leading).offset(-5)
        }
        
        
        [titleLabel, buisnessLabel, usageLabel, cidoLabel, explanationLabel].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            infoView.addSubview($0)
        }
        titleLabel.snp.makeConstraints{
            $0.top.equalTo(infoView)
            $0.leading.equalTo(infoView)
            $0.trailing.equalTo(infoView)
        }
        buisnessLabel.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
            $0.leading.equalTo(infoView)
        }
        usageLabel.snp.makeConstraints{
            $0.top.equalTo(buisnessLabel)
            $0.leading.equalTo(buisnessLabel.snp.trailing).offset(10)
        }
        cidoLabel.snp.makeConstraints{
            $0.top.equalTo(buisnessLabel)
            $0.leading.equalTo(usageLabel.snp.trailing).offset(10)
        }
        explanationLabel.snp.makeConstraints{
            $0.top.equalTo(buisnessLabel.snp.bottom).offset(5)
            $0.leading.equalTo(buisnessLabel)
            $0.trailing.equalTo(infoView)
            $0.bottom.equalTo(infoView).offset(-5)
        }
        
        [carrerView, favoriteView, reviewView].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            borderView.addSubview($0)
        }
        carrerView.snp.makeConstraints{
            $0.top.equalTo(infoView.snp.bottom).offset(5)
            $0.leading.equalTo(borderView)
        }
        favoriteView.snp.makeConstraints{
            $0.top.equalTo(carrerView)
            $0.leading.equalTo(carrerView.snp.trailing)
            $0.width.equalTo(carrerView)
            $0.bottom.equalTo(carrerView)
        }
        reviewView.snp.makeConstraints{
            $0.top.equalTo(carrerView)
            $0.leading.equalTo(favoriteView.snp.trailing)
            $0.width.equalTo(carrerView)
            $0.trailing.equalTo(infoView)
            $0.bottom.equalTo(carrerView)
        }
        
        [favoriteButton, reviewButton].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            borderView.addSubview($0)
        }
        favoriteButton.snp.makeConstraints{
            $0.top.equalTo(carrerView.snp.bottom).offset(5)
            $0.leading.equalTo(borderView)
        }
        reviewButton.snp.makeConstraints{
            $0.top.equalTo(favoriteButton)
            $0.leading.equalTo(favoriteButton.snp.trailing)
            $0.trailing.equalTo(borderView)
            $0.width.equalTo(favoriteButton)
            $0.bottom.equalTo(borderView)
        }
    }
}



class WaplaceExpertInnerView: UIView {
    
    var innerModel: (String, String)? {
        didSet{
            guard let model = innerModel else {return}
            titleLabel.text = model.0
            contentsLabel.text = model.1
        }
    }
    
    let titleLabel = UILabel().then{
        $0.textColor = UIColor(rgb: 0x4a4a4a)
        $0.font = UIFont.systemFont(ofSize: 14)
    }
    let contentsLabel = UILabel().then{
        $0.textColor = UIColor(rgb: 0x4a4a4a)
        $0.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        uiSetting()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func uiSetting(){
        [titleLabel, contentsLabel].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        titleLabel.snp.makeConstraints{
            $0.top.equalTo(self).offset(10)
            $0.centerX.equalTo(self)
        }
        contentsLabel.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
            $0.centerX.equalTo(titleLabel)
            $0.bottom.equalTo(self).offset(-10)
        }
    }
}
