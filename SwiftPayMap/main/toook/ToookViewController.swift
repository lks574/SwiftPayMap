//
//  ToookViewController.swift
//  SwiftPayMap
//
//  Created by KyungSeok Lee on 2019. 3. 18..
//  Copyright © 2019년 KyungSeok Lee. All rights reserved.
//

import UIKit
import Then
import SnapKit

class ToookViewController: UIViewController {

    let naviView = UIView().then{
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let titleView = UIView().then{
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let bagView = UIView().then{
        $0.layer.borderColor = Colors.textColors.cgColor
        $0.layer.borderWidth = 1.5
        $0.layer.cornerRadius = 10
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let checkView = UIView().then{
        $0.layer.borderColor = Colors.textColors.cgColor
        $0.layer.borderWidth = 1.5
        $0.layer.cornerRadius = 10
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let calendarView = CalenderView2(theme: .light).then{
        $0.layer.borderColor = Colors.textColors.cgColor
        $0.layer.borderWidth = 1.5
        $0.layer.cornerRadius = 10
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(rgb: 0xf8eae0)
        self.navigationController?.isNavigationBarHidden = true
        uiSetting()
    }
    
    @objc private func backButtonAction(_ sender: UIButton){
        
    }

}


// View
extension ToookViewController {
    
    struct Colors {
        static let textColors = UIColor.black
    }
    
    private func uiSetting(){
        naviSetting()
        titleSetting()
        bagSetting()
        checkSetting()
        calendarViewSetting()
    }
    
    private func naviSetting(){
        let backButton : UIButton = {
            let btn = UIButton()
            btn.setTitle("back", for: .normal)
            btn.setTitleColor(Colors.textColors, for: .normal)
            btn.addTarget(self, action: #selector(backButtonAction(_:)), for: .touchUpInside)
            return btn
        }()
        
        let rightButton = UIButton().then{
            $0.setImage(UIImage(named: "hamburger-black"), for: .normal)
        }
        self.view.addSubview(naviView)
        [backButton, rightButton].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            naviView.addSubview($0)
        }
        naviView.snp.makeConstraints{
            $0.top.equalTo(self.view.safeArea.top)
            $0.leading.equalTo(self.view)
            $0.trailing.equalTo(self.view)
        }
        backButton.snp.makeConstraints{
            $0.top.equalTo(naviView).offset(8)
            $0.leading.equalTo(naviView).offset(16)
            $0.bottom.equalTo(naviView).offset(-8)
        }
        rightButton.snp.makeConstraints{
            $0.top.equalTo(backButton)
            $0.trailing.equalTo(naviView).offset(-16)
            $0.bottom.equalTo(backButton)
        }
    }
    
    private func titleSetting(){
        let mapImageView = UIImageView().then{
            $0.image = UIImage(named: "search-black")
        }
        let titleLabel = UILabel().then{
            $0.text = "Area"
            $0.font = UIFont.systemFont(ofSize: 20)
        }
        self.view.addSubview(titleView)
        [mapImageView, titleLabel].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            titleView.addSubview($0)
        }
        titleView.snp.makeConstraints{
            $0.top.equalTo(naviView.snp.bottom).offset(10)
            $0.centerX.equalTo(self.view)
            $0.width.equalTo(self.view).multipliedBy(0.7)
        }
        mapImageView.snp.makeConstraints{
            $0.centerY.equalTo(titleView)
            $0.leading.equalTo(titleView)
        }
        titleLabel.snp.makeConstraints{
            $0.centerX.equalTo(titleView)
            $0.top.equalTo(titleView).offset(8)
            $0.bottom.equalTo(titleView).offset(-8)
        }
    }
    
    private func bagSetting(){
        let bagLabel = UILabel().then{
            $0.text = "Bag"
            $0.textColor = Colors.textColors
        }
        let stackView = UIStackView().then{
            $0.axis = .horizontal
        }
        let minusButton = UIButton().then{
            $0.setTitle("-", for: .normal)
            $0.setTitleColor(Colors.textColors, for: .normal)
        }
        let bagNumber = UILabel().then{
            $0.text = "10"
            $0.textColor = Colors.textColors
            $0.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        }
        let plusButton = UIButton().then{
            $0.setTitle("+", for: .normal)
            $0.setTitleColor(Colors.textColors, for: .normal)
        }
        self.view.addSubview(bagView)
        [bagLabel, stackView].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            bagView.addSubview($0)
        }
        [minusButton,bagNumber, plusButton].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview($0)
        }
        bagView.snp.makeConstraints{
            $0.top.equalTo(titleView.snp.bottom).offset(20)
            $0.leading.equalTo(titleView)
            $0.trailing.equalTo(titleView)
        }
        bagLabel.snp.makeConstraints{
            $0.top.equalTo(bagView).offset(16)
            $0.leading.equalTo(bagView).offset(8)
            $0.bottom.equalTo(bagView).offset(-16)
        }
        stackView.snp.makeConstraints{
            $0.centerY.equalTo(bagLabel)
            $0.leading.equalTo(bagLabel.snp.trailing).offset(20)
            $0.trailing.equalTo(bagView).offset(-8)
        }
    }
    
    private func checkSetting(){
        let checkInLabel = UILabel().then{
            $0.text = "Check\nIN"
            $0.textColor = Colors.textColors
            $0.numberOfLines = 2
        }
        let checkOutLabel = UILabel().then{
            $0.text = "Check\nOUT"
            $0.textColor = Colors.textColors
            $0.numberOfLines = 2
        }
        
        self.view.addSubview(checkView)
        [checkInLabel, checkOutLabel].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            checkView.addSubview($0)
        }
        checkView.snp.makeConstraints{
            $0.top.equalTo(bagView.snp.bottom).offset(20)
            $0.leading.equalTo(titleView)
            $0.trailing.equalTo(titleView)
        }
        checkInLabel.snp.makeConstraints{
            $0.top.equalTo(checkView).offset(10)
            $0.centerX.equalTo(checkView).multipliedBy(0.5)
            $0.bottom.equalTo(checkView).offset(-10)
        }
        checkOutLabel.snp.makeConstraints{
            $0.top.equalTo(checkInLabel)
            $0.centerX.equalTo(checkView).multipliedBy(1.5)
            $0.bottom.equalTo(checkInLabel)
        }
    }
    
    private func calendarViewSetting(){
        self.view.addSubview(calendarView)
        calendarView.snp.makeConstraints{
            $0.top.equalTo(checkView.snp.bottom).offset(30)
            $0.centerX.equalTo(self.view)
            $0.width.equalTo(self.view).multipliedBy(0.9)
            $0.bottom.equalTo(self.view.safeArea.bottom).offset(-10)
        }
    }
}
