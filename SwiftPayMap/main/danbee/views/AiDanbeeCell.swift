//
//  AiDanbeeCell.swift
//  SwiftPayMap
//
//  Created by KyungSeok Lee on 2019. 3. 11..
//  Copyright © 2019년 KyungSeok Lee. All rights reserved.
//

import Foundation
import UIKit
import Then
import SnapKit
import RxSwift

class AiDanbeeCell: UITableViewCell {
    var disposeBag = DisposeBag()
    let buttonSubject = PublishSubject<String>()
    
    var optionsArray = [BubbleOption]() {
        didSet{
            buttonSetting()
        }
    }
    
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
    
    let stackButtons = UIStackView().then{
        $0.axis = .vertical
        $0.spacing = 3.0
    }
    
    init(reuseIdentifier: String){
        super.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = UIColor.white
        uiSetting()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.myMessage.text = ""
        mainImageView.image = nil
        optionsArray = []
        disposeBag = DisposeBag()
    }
    
    
    @objc private func optionAction(_ sender: UIButton){
        guard let titleText = sender.titleLabel?.text else { return }
        buttonSubject.asObserver().onNext(titleText)
    }
    
    private func uiSetting(){
//        let optionButton = UIButton().then{
//            $0.setTitle("브랜드 소개", for: .normal)
//            $0.setTitleColor(UIColor.white, for: .normal)
//            $0.backgroundColor = UIColor.blue
//            $0.addTarget(self, action: #selector(optionAction(_:)), for: .touchUpInside)
//        }
    
        [bubbleView].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview($0)
        }
        [mainImageView, myMessage, stackButtons].forEach{
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
        }
        stackButtons.snp.makeConstraints{
            $0.top.equalTo(myMessage.snp.bottom).inset(-10)
            $0.centerX.equalTo(bubbleView)
            $0.width.equalTo(bubbleView).multipliedBy(0.8)
            $0.bottom.equalTo(bubbleView).offset(-10)
        }
        
//        optionButton.snp.makeConstraints{
//            $0.top.equalTo(myMessage.snp.bottom).inset(-10)
//            $0.centerX.equalTo(bubbleView)
//            $0.width.equalTo(bubbleView).multipliedBy(0.8)
//            $0.bottom.equalTo(bubbleView).offset(-10)
//        }
        
        
    }
    
    private func buttonSetting(){
        optionsArray.forEach{ model in
            let optionButton = UIButton().then{
                $0.setTitle(model.label, for: .normal)
                $0.setTitleColor(UIColor.white, for: .normal)
                $0.backgroundColor = UIColor.blue
                $0.addTarget(self, action: #selector(optionAction(_:)), for: .touchUpInside)
            }
            stackButtons.addArrangedSubview(optionButton)
        }
    }
}
