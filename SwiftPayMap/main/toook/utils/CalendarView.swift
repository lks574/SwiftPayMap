//
//  CalendarView.swift
//  SwiftPayMap
//
//  Created by KyungSeok Lee on 2019. 3. 18..
//  Copyright © 2019년 KyungSeok Lee. All rights reserved.
//

import Foundation
import Then
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources
import RxViewController
import RxOptional


class CalendarView: UIView {
    

    var disposeBag = DisposeBag()
    struct Identifier {
        static let monthCell = "CalendarCollectionViewCell"
    }
    struct Metric {
        static let lineSpacing: CGFloat = 10
        static let intetItemSpacing: CGFloat = 10
        static let edgeInset: CGFloat = 8
    }
    
    let topView = UIView().then{
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let titleLabel = UILabel().then{
        $0.text = "February 2019"
        $0.textColor = UIColor.black
        $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
    }
    let leftButton = UIButton().then{
        $0.setImage(UIImage(named: "hamburger-black"), for: .normal)
    }
    let rightButton = UIButton().then{
        $0.setImage(UIImage(named: "arrow-right-small"), for: .normal)
    }
    
    let weekStackView = UIStackView().then{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.alignment = .fill
    }
    
    let monthCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then{
        $0.register(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: Identifier.monthCell)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        uiSetting()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func binding(){
        monthCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
}

extension CalendarView {
    
    private func uiSetting(){
        topViewSetting()
        weekLabelSetting()
    }
    
    // 월 년도, 좌우 버튼
    private func topViewSetting(){
        self.addSubview(topView)
        [leftButton, titleLabel, rightButton].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            topView.addSubview($0)
        }
        topView.snp.makeConstraints{
            $0.top.equalTo(self).offset(5)
            $0.leading.equalTo(self)
            $0.trailing.equalTo(self)
        }
        titleLabel.snp.makeConstraints{
            $0.centerX.equalTo(topView)
            $0.top.equalTo(topView).offset(5)
            $0.bottom.equalTo(topView).offset(-5)
        }
        leftButton.snp.makeConstraints{
            $0.leading.equalTo(topView).offset(8)
            $0.centerY.equalTo(titleLabel)
        }
        rightButton.snp.makeConstraints{
            $0.trailing.equalTo(topView).offset(-8)
            $0.centerY.equalTo(titleLabel)
        }
    }

    private func weekLabelSetting(){
        let weekArr = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
        
        self.addSubview(weekStackView)
        weekArr.forEach{
            let label = UILabel()
            label.text = $0
            label.textColor = UIColor.black
            label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            label.translatesAutoresizingMaskIntoConstraints = false
            weekStackView.addArrangedSubview(label)
        }
        weekStackView.snp.makeConstraints{
            $0.centerX.equalTo(self)
            $0.width.equalTo(self).multipliedBy(0.9)
            $0.top.equalTo(topView.snp.bottom).offset(10)
            $0.bottom.equalTo(self)
        }
    }
}

extension CalendarView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.size.width - 40) * 0.33, height: (collectionView.bounds.size.width - 40) * 0.33)
    }
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Metric.lineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Metric.intetItemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: Metric.edgeInset,left: Metric.edgeInset,bottom: Metric.edgeInset,right: Metric.edgeInset)
    }
}




class CalendarCollectionViewCell : UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
