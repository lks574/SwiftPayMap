//
//  WaPlaceSearchViewController.swift
//  SwiftPayMap
//
//  Created by KyungSeok Lee on 2019. 3. 14..
//  Copyright © 2019년 KyungSeok Lee. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import RxOptional
import RxViewController

class WaPlaceSearchViewController: UIViewController {
    var disposeBag = DisposeBag()
    
    let tableViewModel = BehaviorSubject<[WaplaceMainTableModel]>(value: [])

    
    struct CustomColor {
        static let mainColor = UIColor(rgb: 0x4a4a4a)
    }
    struct Identifier {
        static let mainTableCell = "WaplaceTableViewCell"
    }
    
    let infoTitleLabel = UILabel().then{
        $0.text = "어서오세요 박민석님!"
        $0.textColor = UIColor.black
        $0.font = UIFont.systemFont(ofSize: 16)
    }
    let logoutButton = UIButton().then{
        $0.setTitle("로그아웃", for: .normal)
        $0.setTitleColor(CustomColor.mainColor, for: .normal)
        $0.backgroundColor = UIColor.white
        $0.layer.borderColor = CustomColor.mainColor.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 5
        $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    let myInfoButtonStackView = UIStackView().then{
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fillEqually
    }
    let userInfoButton = ImageLabelButton()
    let myWriteButton = ImageLabelButton()
    let favoriteButton = ImageLabelButton()
    
    let mainTableView = UITableView(frame: .zero, style: UITableView.Style.plain).then{
        $0.tableFooterView = UIView(frame: .zero)
        $0.register(WaplaceTableViewCell.self, forCellReuseIdentifier: Identifier.mainTableCell)
//        $0.estimatedRowHeight = 80
//        $0.rowHeight = UITableView.automaticDimension
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "와플 검색"
        uiSetting()
        etcSetting()
        binding()
        
        let xNaviButton = UIBarButtonItem(image: UIImage(named: "close-black"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(naviButtonAction(_:)))
        xNaviButton.tag = 0
        
        let serachButton = UIBarButtonItem(image: UIImage(named: "search-black"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(naviButtonAction(_:)))
        serachButton.tag = 1
        
        self.navigationItem.rightBarButtonItems = [xNaviButton, serachButton]
    }
    
    @objc private func naviButtonAction(_ sender: UIBarButtonItem){
        if sender.tag == 0 {
            self.navigationController?.popViewController(animated: true)
        }else{
            
        }
    }
    
    private func etcSetting(){
        userInfoButton.textStr = "회원정보"
        userInfoButton.imageStr = "search-black"
        
        myWriteButton.textStr = "내가 쓴 글"
        myWriteButton.imageStr = "search-black"
        
        favoriteButton.textStr = "찜"
        favoriteButton.imageStr = "search-black"
        
        tableViewModel.asObserver()
            .onNext([WaplaceMainTableModel(titleStr:["사진","전문가","매거진","질문과 답변","견전&입찰","쇼핑몰", "게시판"])])
    }
    
    private func binding(){
        logoutButton.rx.tap
            .subscribe(onNext:{
                
            }).disposed(by: disposeBag)
        
        
        let dataSources = RxTableViewSectionedReloadDataSource<WaplaceMainTableModel>(configureCell: {(dataSource, tableView, indexPath, item) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.mainTableCell, for: indexPath) as! WaplaceTableViewCell
            cell.mainLabel.text = item
            return cell
        })
        
//        mainTableView.rx.setDataSource(dataSources).disposed(by: disposeBag)
        
        tableViewModel.asDriver(onErrorJustReturn: [])
            .drive(mainTableView.rx.items(dataSource: dataSources))
            .disposed(by: disposeBag)
        
        mainTableView.rx.itemSelected.asDriver()
            .drive(onNext:{ [weak self] indexPath in
                self?.mainTableView.deselectRow(at: indexPath, animated: true)
                
                switch indexPath.row {
                case 0:
                    break
                case 1:
                    let vc = WaplaceExpertViewController()
                    self?.navigationController?.pushViewController(vc, animated: true)
                    break
                default:
                    break
                }
            }).disposed(by: disposeBag)
        
    }
    
    private func uiSetting(){
       
        let topView = UIView()
        [topView, mainTableView].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview($0)
        }
        topView.snp.makeConstraints{
            $0.top.equalTo(self.view.safeArea.top)
            $0.leading.equalTo(self.view)
            $0.trailing.equalTo(self.view)
        }
        mainTableView.snp.makeConstraints{
            $0.top.equalTo(topView.snp.bottom).offset(10)
            $0.leading.equalTo(self.view)
            $0.trailing.equalTo(self.view)
            $0.bottom.equalTo(self.view.safeArea.bottom)
        }
    
        
        [infoTitleLabel, logoutButton ,myInfoButtonStackView].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            topView.addSubview($0)
        }
        infoTitleLabel.snp.makeConstraints{
            $0.top.equalTo(topView).offset(15)
            $0.leading.equalTo(topView).offset(10)
            $0.trailing.equalTo(topView).offset(-10)
        }
        logoutButton.snp.makeConstraints{
            $0.top.equalTo(infoTitleLabel)
            $0.trailing.equalToSuperview().offset(-10)
            $0.bottom.equalTo(infoTitleLabel)
        }
        myInfoButtonStackView.snp.makeConstraints{
            $0.top.equalTo(infoTitleLabel.snp.bottom).offset(10)
            $0.leading.equalTo(topView).offset(10)
            $0.trailing.equalTo(topView).offset(-10)
            $0.height.equalTo(60)
            $0.bottom.equalTo(topView).offset(-10)
            
        }
        
        [userInfoButton, myWriteButton, favoriteButton].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            myInfoButtonStackView.addArrangedSubview($0)
        }
    
    }

}



class ImageLabelButton : UIButton {
    
    var imageStr = "" {
        didSet{
            mainImageView.image = UIImage(named: imageStr)
        }
    }
    var textStr = "" {
        didSet{
            textLabel.text = textStr
        }
    }
    
    let mainImageView = UIImageView().then{
        $0.contentMode = .scaleAspectFit
    }
    let textLabel = UILabel().then{
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = UIColor(rgb: 0x4a4a4a)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        uiSetting()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func uiSetting(){
        [mainImageView, textLabel].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        mainImageView.snp.makeConstraints{
            $0.centerX.equalTo(self)
            $0.centerY.equalTo(self).offset(-5)
        }
        textLabel.snp.makeConstraints{
            $0.centerX.equalTo(mainImageView)
            $0.top.equalTo(mainImageView.snp.bottom).offset(3)
        }
    }
}

