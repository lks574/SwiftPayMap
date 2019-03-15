//
//  WaplaceExpertDetailViewController.swift
//  SwiftPayMap
//
//  Created by KyungSeok Lee on 14/03/2019.
//  Copyright © 2019 KyungSeok Lee. All rights reserved.
//

import Foundation
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources
import RxOptional
import RxViewController

/** 전문가 정보 */
class WaplaceExpertDetailViewController: UIViewController {

    var disposeBag = DisposeBag()
    
    let topView = InnerTopView()
    let menuView = InnerMenuView()
    
    let tabViews = UIView()
    let profileView = InnerProfileView()
    let portfolioView = InnerPortfolioView()
    let reviewView = InnerReviewView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "전문가 디테일"
        
        uiSetting()
        binding()
    }
    
    private func tapViews(tag: Int){
        switch tag {
        case 0:
            profileView.isHidden = false
            portfolioView.isHidden = true
            reviewView.isHidden = true
            break
        case 1:
            profileView.isHidden = true
            portfolioView.isHidden = false
            reviewView.isHidden = true
            break
        case 2:
            profileView.isHidden = true
            portfolioView.isHidden = true
            reviewView.isHidden = false
            break
        default:
            break
        }
    }
    
    private func binding(){
        
        // 메뉴 버튼들의 엑션 merge
        Observable.merge(menuView.profileButton.rx.tap.asObservable().map{0}, menuView.portfolioButton.rx.tap.asObservable().map{1}, menuView.reviewButton.rx.tap.asObservable().map{2})
            .subscribe(onNext:{ [weak self] tag in
                self?.menuView.menuModel = tag
                self?.tapViews(tag: tag)
            }).disposed(by: disposeBag)
    }
    
    private func uiSetting(){
        reviewView.isHidden = true
        portfolioView.isHidden = true
        
        topView.innerModel = InnerTopModel(title: "본구조엔지니어링건축사무소", imageStr: "search-black", buisnessType: "개인사업자", cido: "서울", UsageType: "실내인테리어", career: "3년", phone: "02-0000-0000", homepage: "www.waple.com")
        profileView.innerModel = [("전문가 소개", "방황하였으며, \n\n붙잡아 못할 열락의 가슴이 이상의 풀이 뜨고"),("전문영역","1차 카테고리,2차 카테고리"),("주요분야", "실내인테리어"),("사업자 정보", "개인사업자"),("소재지", "서울특별시 강남구 신사동 634-15 우진빌딩 4F"), ("보유경력", "4년\n\n\n\n\n123")]
        portfolioView.innerPortfolioModel.onNext([InnerPortfolioViewSectionModel(model: [InnerPortfolioViewModel.init(imageStr: "search-black", title: "블랙앤화이트", company: "(주)광우티엔씨", category: "1차 카테고리", like: "999", views: "900", comment: "1000") , InnerPortfolioViewModel.init(imageStr: "search-black", title: "블랙앤화이트", company: "(주)광우티엔씨", category: "2차 카테고리", like: "509", views: "1", comment: "1000"), InnerPortfolioViewModel.init(imageStr: "search-black", title: "블랙앤화이트", company: "(주)광우티엔씨", category: "3차 카테고리", like: "509", views: "1", comment: "1000")])])
        reviewView.innerReviewModel.onNext([InnerReviewViewSectionModel(model: [InnerReviewViewModel.init(title: "솔직한 이용후기", writeName: "김덕배", date: "2019-03-04", views: "123"), InnerReviewViewModel.init(title: "솔직한 이용후기", writeName: "이경석", date: "2019-01-04", views: "10")])])
        
        
        [topView, menuView, tabViews].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview($0)
        }
        topView.snp.makeConstraints{
            $0.top.equalTo(self.view.safeArea.top)
            $0.leading.equalTo(self.view)
            $0.trailing.equalTo(self.view)
        }
        menuView.snp.makeConstraints{
            $0.top.equalTo(topView.snp.bottom).offset(10)
            $0.leading.equalTo(self.view)
            $0.trailing.equalTo(self.view)
        }
        tabViews.snp.makeConstraints{
            $0.top.equalTo(menuView.snp.bottom).offset(5)
            $0.leading.equalTo(self.view)
            $0.trailing.equalTo(self.view)
            $0.bottom.equalTo(self.view.safeArea.bottom)
        }
        
        [profileView, portfolioView, reviewView].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            tabViews.addSubview($0)
            
            $0.snp.makeConstraints({ (make) in
                make.edges.equalTo(tabViews)
            })
        }
    }
    
    
}

extension WaplaceExpertDetailViewController {
    
    /** 상단의 기업 정보 모델 */
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
    
    
    /** 상단의 기업 정보 View */
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
    
    /** 프로필, 포트폴리오, 리뷰 선택 버튼 */
    class InnerMenuView : UIView{
        
        var menuModel: Int?{
            didSet{
                guard let model = menuModel else { return }
                self.buttonBarAnimation(tag: model)
            }
        }
        
        let profileButton = UIButton().then{
            $0.setTitle("프로필", for: .normal)
            $0.setTitleColor(UIColor(rgb: 0x4a4a4a), for: .normal)
        }
        let portfolioButton = UIButton().then{
            $0.setTitle("포트폴리오", for: .normal)
            $0.setTitleColor(UIColor(rgb: 0x4a4a4a), for: .normal)
        }
        let reviewButton = UIButton().then{
            $0.setTitle("리뷰", for: .normal)
            $0.setTitleColor(UIColor(rgb: 0x4a4a4a), for: .normal)
        }
        let bottomView = UIView(frame: .zero).then{
            $0.backgroundColor = UIColor(rgb: 0x4a4a4a)
        }
        
        private var bottomViewLeading : Constraint!
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            uiSetting()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func buttonBarAnimation(tag: Int){
            let width = self.frame.width / 3 * CGFloat(tag)
            UIView.animate(withDuration: 0.5, animations: {
                 self.bottomViewLeading.update(offset: width)
            }, completion: nil)
        }
        
        private func uiSetting(){
            [profileButton, portfolioButton, reviewButton, bottomView].forEach{
                $0.translatesAutoresizingMaskIntoConstraints = false
                self.addSubview($0)
            }
            profileButton.snp.makeConstraints{
                $0.height.equalTo(50)
                $0.top.equalTo(self)
                $0.leading.equalTo(self)
                $0.bottom.equalTo(self)
            }
            portfolioButton.snp.makeConstraints{
                $0.top.equalTo(profileButton)
                $0.leading.equalTo(profileButton.snp.trailing)
                $0.width.equalTo(profileButton)
                $0.bottom.equalTo(profileButton)
            }
            reviewButton.snp.makeConstraints{
                $0.top.equalTo(profileButton)
                $0.leading.equalTo(portfolioButton.snp.trailing)
                $0.width.equalTo(profileButton)
                $0.bottom.equalTo(profileButton)
                $0.trailing.equalTo(self)
            }
            bottomView.snp.makeConstraints{
                $0.height.equalTo(2)
                bottomViewLeading = $0.leading.equalTo(self.snp.leading).constraint
                $0.width.equalTo(self.snp.width).multipliedBy(0.333334)
                $0.bottom.equalTo(self.snp.bottom)
            }
        }
    }
    
    
    /** 프로필 View */
    class InnerProfileView: UIView{
        
        struct Offset{
            static let margin = 10
        }
        
        var innerModel: [(String, String)]? {
            didSet{
                guard let model = innerModel else { return }
                expertTitleLabel.text = model[0].0
                expertTextLabel.text = model[0].1
                professionalTitleLabel.text = model[1].0
                professionalTextLabel.text = model[1].1
                majorTitleLabel.text = model[2].0
                majorTextLabel.text = model[2].1
                companyTitleLabel.text = model[3].0
                companyTextLabel.text = model[3].1
                areaTitleLabel.text = model[4].0
                areaTextLabel.text = model[4].1
                careerTitleLabel.text = model[5].0
                careerTextLabel.text = model[5].1
            }
        }
       
        private let expertTitleLabel = UILabel()
        private let expertTextLabel = UILabel()
        private let professionalTitleLabel = UILabel()
        private let professionalTextLabel = UILabel()
        private let majorTitleLabel = UILabel()
        private let majorTextLabel = UILabel()
        private let companyTitleLabel = UILabel()
        private let companyTextLabel = UILabel()
        private let areaTitleLabel = UILabel()
        private let areaTextLabel = UILabel()
        private let careerTitleLabel = UILabel()
        private let careerTextLabel = UILabel()
        
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            uiSetting()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        

        private func uiSetting(){
            let mainScrollView = UIScrollView()
            let contentsView = UIView()
            
            let expertView = UIView()
            let professionalView = UIView()
            let majorView = UIView()
            let companyView = UIView()
            let areaView = UIView()
            let careerView = UIView()
            
            [mainScrollView].forEach{
                $0.translatesAutoresizingMaskIntoConstraints = false
                self.addSubview($0)
            }
            mainScrollView.snp.makeConstraints{
                $0.edges.equalTo(self)
            }
            
            [contentsView].forEach{
                $0.translatesAutoresizingMaskIntoConstraints = false
                mainScrollView.addSubview($0)
            }
            contentsView.snp.makeConstraints{
                $0.top.equalTo(mainScrollView)
                $0.leading.equalTo(mainScrollView)
                $0.trailing.equalTo(mainScrollView)
                $0.centerX.equalTo(mainScrollView)
                $0.bottom.equalTo(mainScrollView)
            }
            
            [expertView, professionalView, majorView, companyView, areaView, careerView].forEach{
                $0.layer.cornerRadius = 2
                $0.layer.borderWidth = 1
                $0.layer.borderColor = UIColor(rgb: 0xcccccc).cgColor
                
                $0.translatesAutoresizingMaskIntoConstraints = false
                contentsView.addSubview($0)
            }
            expertView.snp.makeConstraints{
                $0.top.equalTo(contentsView).offset(Offset.margin)
                $0.leading.equalTo(contentsView).offset(Offset.margin)
                $0.trailing.equalTo(contentsView).offset(-Offset.margin)
            }
            professionalView.snp.makeConstraints{
                $0.top.equalTo(expertView.snp.bottom).offset(Offset.margin)
                $0.leading.equalTo(expertView)
                $0.trailing.equalTo(expertView)
            }
            majorView.snp.makeConstraints{
                $0.top.equalTo(professionalView.snp.bottom).offset(Offset.margin)
                $0.leading.equalTo(expertView)
                $0.trailing.equalTo(expertView)
            }
            companyView.snp.makeConstraints{
                $0.top.equalTo(majorView.snp.bottom).offset(Offset.margin)
                $0.leading.equalTo(expertView)
                $0.trailing.equalTo(expertView)
            }
            areaView.snp.makeConstraints{
                $0.top.equalTo(companyView.snp.bottom).offset(Offset.margin)
                $0.leading.equalTo(expertView)
                $0.trailing.equalTo(expertView)
            }
            careerView.snp.makeConstraints{
                $0.top.equalTo(areaView.snp.bottom).offset(Offset.margin)
                $0.leading.equalTo(expertView)
                $0.trailing.equalTo(expertView)
                $0.bottom.equalTo(contentsView).offset(-Offset.margin)
            }
            
            [expertTitleLabel, professionalTitleLabel, majorTitleLabel, companyTitleLabel, areaTitleLabel, careerTitleLabel].forEach{
                $0.textColor = UIColor(rgb: 0x4a4a4a)
                $0.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            }
            [expertTextLabel, professionalTextLabel, majorTextLabel, companyTextLabel, areaTextLabel, careerTextLabel].forEach{
                $0.textColor = UIColor(rgb: 0x777777)
                $0.font = UIFont.systemFont(ofSize: 13)
                $0.numberOfLines = 0
            }
            
            [expertTitleLabel, expertTextLabel].forEach{
                $0.translatesAutoresizingMaskIntoConstraints = false
                expertView.addSubview($0)
            }
            expertTitleLabel.snp.makeConstraints{
                $0.top.equalTo(expertView).offset(Offset.margin)
                $0.leading.equalTo(expertView).offset(Offset.margin)
                $0.trailing.equalTo(expertView).offset(-Offset.margin)
            }
            expertTextLabel.snp.makeConstraints{
                $0.top.equalTo(expertTitleLabel.snp.bottom).offset(Offset.margin)
                $0.leading.equalTo(expertTitleLabel)
                $0.trailing.equalTo(expertTitleLabel)
                $0.bottom.equalTo(expertView).offset(-Offset.margin)
            }
            
            [professionalTitleLabel, professionalTextLabel].forEach{
                $0.translatesAutoresizingMaskIntoConstraints = false
                professionalView.addSubview($0)
            }
            professionalTitleLabel.snp.makeConstraints{
                $0.top.equalTo(professionalView).offset(Offset.margin)
                $0.leading.equalTo(professionalView).offset(Offset.margin)
                $0.trailing.equalTo(professionalView).offset(-Offset.margin)
            }
            professionalTextLabel.snp.makeConstraints{
                $0.top.equalTo(professionalTitleLabel.snp.bottom).offset(Offset.margin)
                $0.leading.equalTo(professionalTitleLabel)
                $0.trailing.equalTo(professionalTitleLabel)
                $0.bottom.equalTo(professionalView).offset(-Offset.margin)
            }
            
            [majorTitleLabel, majorTextLabel].forEach{
                $0.translatesAutoresizingMaskIntoConstraints = false
                majorView.addSubview($0)
            }
            majorTitleLabel.snp.makeConstraints{
                $0.top.equalTo(majorView).offset(Offset.margin)
                $0.leading.equalTo(majorView).offset(Offset.margin)
                $0.trailing.equalTo(majorView).offset(-Offset.margin)
            }
            majorTextLabel.snp.makeConstraints{
                $0.top.equalTo(majorTitleLabel.snp.bottom).offset(Offset.margin)
                $0.leading.equalTo(majorTitleLabel)
                $0.trailing.equalTo(majorTitleLabel)
                $0.bottom.equalTo(majorView).offset(-Offset.margin)
            }
            
            [companyTitleLabel, companyTextLabel].forEach{
                $0.translatesAutoresizingMaskIntoConstraints = false
                companyView.addSubview($0)
            }
            companyTitleLabel.snp.makeConstraints{
                $0.top.equalTo(companyView).offset(Offset.margin)
                $0.leading.equalTo(companyView).offset(Offset.margin)
                $0.trailing.equalTo(companyView).offset(-Offset.margin)
            }
            companyTextLabel.snp.makeConstraints{
                $0.top.equalTo(companyTitleLabel.snp.bottom).offset(Offset.margin)
                $0.leading.equalTo(companyTitleLabel)
                $0.trailing.equalTo(companyTitleLabel)
                $0.bottom.equalTo(companyView).offset(-Offset.margin)
            }
            
            [areaTitleLabel, areaTextLabel].forEach{
                $0.translatesAutoresizingMaskIntoConstraints = false
                areaView.addSubview($0)
            }
            areaTitleLabel.snp.makeConstraints{
                $0.top.equalTo(areaView).offset(Offset.margin)
                $0.leading.equalTo(areaView).offset(Offset.margin)
                $0.trailing.equalTo(areaView).offset(-Offset.margin)
            }
            areaTextLabel.snp.makeConstraints{
                $0.top.equalTo(areaTitleLabel.snp.bottom).offset(Offset.margin)
                $0.leading.equalTo(areaTitleLabel)
                $0.trailing.equalTo(areaTitleLabel)
                $0.bottom.equalTo(areaView).offset(-Offset.margin)
            }
            
            [careerTitleLabel, careerTextLabel].forEach{
                $0.translatesAutoresizingMaskIntoConstraints = false
                careerView.addSubview($0)
            }
            careerTitleLabel.snp.makeConstraints{
                $0.top.equalTo(careerView).offset(Offset.margin)
                $0.leading.equalTo(careerView).offset(Offset.margin)
                $0.trailing.equalTo(careerView).offset(-Offset.margin)
            }
            careerTextLabel.snp.makeConstraints{
                $0.top.equalTo(careerTitleLabel.snp.bottom).offset(Offset.margin)
                $0.leading.equalTo(careerTitleLabel)
                $0.trailing.equalTo(careerTitleLabel)
                $0.bottom.equalTo(careerView).offset(-Offset.margin)
            }
        }
    }
    
    
    /** 포트폴리오 탭 */
    class InnerPortfolioView: UIView, UICollectionViewDelegateFlowLayout{
        var disposeBag = DisposeBag()
        let innerPortfolioModel = BehaviorSubject<[InnerPortfolioViewSectionModel]>(value: [])
        
        struct Identifier {
            static let cellName = "InnerPortfolioCollectionCell"
        }
        
        let portfolioCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then{
            $0.register(InnerPortfolioCollectionCell.self, forCellWithReuseIdentifier: Identifier.cellName)
            $0.backgroundColor = UIColor.white
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            uiSetting()
            binding()
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func binding(){
            let dataSoures = RxCollectionViewSectionedReloadDataSource<InnerPortfolioViewSectionModel>(configureCell: {(dataSoure, collectionView, indexPath, item) -> UICollectionViewCell in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifier.cellName, for: indexPath) as! InnerPortfolioCollectionCell
                cell.mainImageView.image = UIImage(named: item.imageStr)
                cell.titleLabel.text = item.title
                cell.detailLabel.text = item.company
                cell.categoryLabel.text = item.category
                return cell
            })
            innerPortfolioModel.asDriver(onErrorJustReturn: [])
                .drive(portfolioCollectionView.rx.items(dataSource: dataSoures))
                .disposed(by: disposeBag)
            portfolioCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        }
        
        private func uiSetting(){
            [portfolioCollectionView].forEach{
                $0.translatesAutoresizingMaskIntoConstraints = false
                self.addSubview($0)
            }
            portfolioCollectionView.snp.makeConstraints{
                $0.edges.equalTo(self)
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = self.frame.width / 2 - 20
            return CGSize(width: width, height: width * 1.3)
        }
    
        func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 10
        }
        
        func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 10
        }
        
        func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        }
        
    }
    
    
    
    /** 리뷰 탭 */
    class InnerReviewView: UIView{
        
        var disposeBag = DisposeBag()
        struct Indentifier {
            static let cellName = "InnerReviewCell"
        }
        
        let innerReviewModel = BehaviorSubject<[InnerReviewViewSectionModel]>(value: [])
        
        let reviewTableView = UITableView(frame: .zero, style: UITableView.Style.plain).then{
            $0.tableFooterView = UIView(frame: .zero)
            $0.register(InnerReviewTableViewCell.self, forCellReuseIdentifier: Indentifier.cellName)
            $0.estimatedRowHeight = 80
            $0.rowHeight = UITableView.automaticDimension
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            uiSetting()
            binding()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func binding(){
            let dataSources = RxTableViewSectionedReloadDataSource<InnerReviewViewSectionModel>(configureCell: {(dataSource, tableView, indexPath, item) -> UITableViewCell in
                let cell = tableView.dequeueReusableCell(withIdentifier: Indentifier.cellName, for: indexPath) as! InnerReviewTableViewCell
                cell.titleLabel.text = item.title
                cell.nameLabel.text = item.writeName
                cell.dateLabel.text = item.date
                cell.viewsLabel.text = item.views
                return cell
            })
            
            reviewTableView.rx.itemSelected.asDriver()
                .drive(onNext:{ [weak self] indexPath in
                    self?.reviewTableView.deselectRow(at: indexPath, animated: true)
                }).disposed(by: disposeBag)
            
            innerReviewModel.asDriver(onErrorJustReturn: [])
                .drive(reviewTableView.rx.items(dataSource: dataSources))
                .disposed(by: disposeBag)
        }
        
        private func uiSetting(){
            [reviewTableView].forEach{
                $0.translatesAutoresizingMaskIntoConstraints = false
                self.addSubview($0)
            }
            reviewTableView.snp.makeConstraints{
                $0.edges.equalTo(self)
            }
        }
    }
}
