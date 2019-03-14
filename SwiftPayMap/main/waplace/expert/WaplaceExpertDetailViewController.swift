//
//  WaplaceExpertDetailViewController.swift
//  SwiftPayMap
//
//  Created by KyungSeok Lee on 14/03/2019.
//  Copyright © 2019 KyungSeok Lee. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import RxOptional
import RxViewController

class WaplaceExpertDetailViewController: UIViewController {

    var disposeBag = DisposeBag()
    
    let topView = InnerTopView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "전문가 디테일"
        
        uiSetting()
        binding()
    }
    
    private func binding(){
        
    }
    
    private func uiSetting(){
        topView.innerModel = InnerTopModel(title: "본구조엔지니어링건축사무소", imageStr: "search-black", buisnessType: "개인사업자", cido: "서울", UsageType: "실내인테리어", career: "3년", phone: "02-0000-0000", homepage: "www.waple.com")
        [topView].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview($0)
        }
        topView.snp.makeConstraints{
            $0.top.equalTo(self.view.safeArea.top)
            $0.leading.equalTo(self.view)
            $0.trailing.equalTo(self.view)
        }
    }
    
    
}

extension WaplaceExpertDetailViewController {
    
    struct InnerTopModel {
        let title: String
        let imageStr: String
        let buisnessType: String
        let cido: String
        let UsageType: String
        let career: String
        let phone: String
        let homepage: String
    }
    
    class InnerTopView: UIView {
        var innerModel : InnerTopModel? {
            didSet{
                guard let model = innerModel else { return }
                titleLabel.text = model.title
                mainImageView.image = UIImage(named: model.imageStr)
                buisnessLabel.text = model.buisnessType
                cidoLabel.text = model.cido
                usageLabel.text = model.UsageType
                carrerValueLabel.text = model.career
                phoneValueLabel.text = model.phone
                homePageValueLabel.text = model.homepage
            }
        }
        
        let titleLabel = UILabel().then{
            $0.textColor = UIColor(rgb: 0x4a4a4a)
            $0.font = UIFont.systemFont(ofSize: 17, weight: .bold)
            $0.numberOfLines = 0
        }
        let certificateView = UIView().then{
            $0.backgroundColor = UIColor(rgb: 0xef6c00)
        }
        let mainImageView = UIImageView().then{
            $0.contentMode = .scaleAspectFit
        }
        
        let buisnessLabel = UILabel().then{
            $0.textColor = UIColor(rgb: 0x777777)
            $0.font = UIFont.systemFont(ofSize: 15)
        }
        let cidoLabel = UILabel().then{
            $0.textColor = UIColor(rgb: 0x777777)
            $0.font = UIFont.systemFont(ofSize: 15)
        }
        let usageLabel = UILabel().then{
            $0.textColor = UIColor(rgb: 0x777777)
            $0.font = UIFont.systemFont(ofSize: 15)
        }
        
        let carrerValueLabel = UILabel().then{
            $0.textColor = UIColor(rgb: 0x4a4a4a)
            $0.font = UIFont.systemFont(ofSize: 15)
        }
        let phoneValueLabel = UILabel().then{
            $0.textColor = UIColor(rgb: 0x4a4a4a)
            $0.font = UIFont.systemFont(ofSize: 15)
        }
        let homePageValueLabel = UILabel().then{
            $0.textColor = UIColor(rgb: 0x4a4a4a)
            $0.font = UIFont.systemFont(ofSize: 15)
        }
        
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            uiSetting()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func uiSetting(){
            let stackView = UIStackView().then{
                $0.axis = .vertical
                $0.distribution = .fillEqually
                $0.alignment = .fill
                $0.spacing = 5.0
            }
            [titleLabel, certificateView, mainImageView, stackView].forEach{
                $0.translatesAutoresizingMaskIntoConstraints = false
                self.addSubview($0)
            }
            titleLabel.snp.makeConstraints{
                $0.top.equalTo(self).offset(10)
                $0.trailing.equalTo(self).offset(-10)
            }
            certificateView.snp.makeConstraints{
                $0.top.equalTo(titleLabel)
                $0.leading.equalTo(self).offset(10)
                $0.trailing.equalTo(titleLabel.snp.leading).offset(-10)
                $0.bottom.equalTo(titleLabel)
                $0.width.equalTo(80)
            }
            mainImageView.snp.makeConstraints{
                $0.top.equalTo(titleLabel.snp.bottom).offset(15)
                $0.leading.equalTo(self).offset(10)
                $0.height.equalTo(mainImageView.snp.width)
            }
            stackView.snp.makeConstraints{
                $0.top.equalTo(mainImageView)
                $0.width.equalTo(self.snp.width).multipliedBy(0.7)
                $0.leading.equalTo(mainImageView.snp.trailing).offset(10)
                $0.trailing.equalTo(self).offset(-10)
                $0.bottom.equalTo(self).offset(-10)
            }
            let firstStackView = UIStackView().then{
                $0.axis = .horizontal
                $0.distribution = .equalCentering
                $0.alignment = .fill
            }
            let secondStackView = UIStackView().then{
                $0.axis = .horizontal
            }
            let thirdStackView = UIStackView().then{
                $0.axis = .horizontal
            }
            let fourthStackView = UIStackView().then{
                $0.axis = .horizontal
            }
            
            let carrerLabel = UILabel().then{
                $0.textColor = UIColor(rgb: 0x777777)
                $0.font = UIFont.systemFont(ofSize: 15)
                $0.text = "경력"
            }
            let phoneLabel = UILabel().then{
                $0.textColor = UIColor(rgb: 0x777777)
                $0.font = UIFont.systemFont(ofSize: 15)
                $0.text = "대표 연락처"
            }
            let homePageLabel = UILabel().then{
                $0.textColor = UIColor(rgb: 0x777777)
                $0.font = UIFont.systemFont(ofSize: 15)
                $0.text = "홈페이지"
            }
            [firstStackView, secondStackView, thirdStackView, fourthStackView].forEach{
                $0.translatesAutoresizingMaskIntoConstraints = false
                stackView.addArrangedSubview($0)
            }
            
            [buisnessLabel, cidoLabel, usageLabel].forEach{
                $0.translatesAutoresizingMaskIntoConstraints = false
                firstStackView.addArrangedSubview($0)
            }
            [carrerLabel, carrerValueLabel].forEach{
                $0.translatesAutoresizingMaskIntoConstraints = false
                secondStackView.addArrangedSubview($0)
            }
            [phoneLabel, phoneValueLabel].forEach{
                $0.translatesAutoresizingMaskIntoConstraints = false
                thirdStackView.addArrangedSubview($0)
            }
            [homePageLabel, homePageValueLabel].forEach{
                $0.translatesAutoresizingMaskIntoConstraints = false
                fourthStackView.addArrangedSubview($0)
            }
            carrerLabel.snp.makeConstraints{
                $0.width.equalTo(100)
            }
            phoneLabel.snp.makeConstraints{
                $0.width.equalTo(carrerLabel)
            }
            homePageLabel.snp.makeConstraints{
                $0.width.equalTo(carrerLabel)
            }
        }
    }
}
