//
//  WaplaceExpertViewController.swift
//  SwiftPayMap
//
//  Created by KyungSeok Lee on 2019. 3. 14..
//  Copyright © 2019년 KyungSeok Lee. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import RxViewController
import RxOptional
import RxKeyboard

// 와플 - 전문가 탭
class WaplaceExpertViewController: UIViewController {

    struct Identifier {
        static let expertCell = "WaplaceExpertTableViewCell"
    }
    
    var disposeBag = DisposeBag()
    let tableModel = BehaviorSubject<[WaplaceExpertCellModel]>(value: [])
    
    let topTitleLabel = UILabel().then{
        $0.textColor = UIColor(rgb: 0x4a4a4a)
        
        $0.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        $0.numberOfLines = 0
    }
    let filterView = UIView().then{
        $0.backgroundColor = UIColor.blue
    }
    let expertTableView = UITableView(frame: .zero, style: UITableView.Style.plain).then{
        $0.tableFooterView = UIView(frame: .zero)
        $0.estimatedRowHeight = 80
        $0.rowHeight = UITableView.automaticDimension
        $0.register(WaplaceExpertTableViewCell.self, forCellReuseIdentifier: Identifier.expertCell)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "전문가"
        
        uiSetting()
        binding()
        topTitleLabel.text = "총 36개의 주거공간 전문가가 있습니다."
    }
    
    private func binding(){
        let models = [WaplaceExpertModel.init(title: "(주)광우티엔씨", imageStr: "search-black", buisnessType: "개인사업자", UsageType: "주거공간", cido: "경기도", explanation: "헤는 나는 별 덮어 거외다. 마리아 사랑과 밤을 같이 새워 보고, 버리었습니다. 별이 내린 별 계십니다. 많은 가을 계집애들의 언덕 어머님, 듯합니다. 하나에 나는 별에도 풀이 잔디가 하나에 하나에 많은 하나에 봅니다. 이름자를 겨울이 우는 벌써 덮어 라이너 듯합니다. ", career: "4년", favorite: "132개", review: "24개"), WaplaceExpertModel.init(title: "(주)광우티엔씨", imageStr: "search-black", buisnessType: "사업자", UsageType: "주거 공간", cido: "서울", explanation: "헤는 나는 별 덮어 거외다.", career: "1년", favorite: "50개", review: "2개")]
        
        tableModel.asObserver()
            .onNext([WaplaceExpertCellModel(item: models)])
        
        let dataSources = RxTableViewSectionedReloadDataSource<WaplaceExpertCellModel>(configureCell: {(dataSource, tableView, indexPath, item) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.expertCell, for: indexPath) as! WaplaceExpertTableViewCell
            cell.cellModel = item
            return cell
        })
        
        tableModel.asDriver(onErrorJustReturn: [])
            .drive(expertTableView.rx.items(dataSource: dataSources))
            .disposed(by: disposeBag)
        
        expertTableView.rx.modelSelected(WaplaceExpertModel.self).asDriver()
            .drive(onNext:{[weak self] item in
                let vc = WaplaceExpertDetailViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            }).disposed(by: disposeBag)
        
        expertTableView.rx.itemSelected.asObservable()
            .subscribe(onNext:{ [weak self] indexPath in
                self?.expertTableView.deselectRow(at: indexPath, animated: true)
            }).disposed(by: disposeBag)
    }
    
    private func uiSetting(){
        [topTitleLabel, filterView, expertTableView].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview($0)
        }
        topTitleLabel.snp.makeConstraints{
            $0.top.equalTo(self.view.safeArea.top).offset(10)
            $0.leading.equalTo(self.view).offset(10)
            $0.trailing.equalTo(self.view).offset(-10)
        }
        filterView.snp.makeConstraints{
            $0.top.equalTo(topTitleLabel.snp.bottom).offset(10)
            $0.leading.equalTo(self.view)
            $0.trailing.equalTo(self.view)
            $0.height.equalTo(50)
        }
        expertTableView.snp.makeConstraints{
            $0.top.equalTo(filterView.snp.bottom).offset(10)
            $0.leading.equalTo(self.view).offset(10)
            $0.trailing.equalTo(self.view).offset(-10)
            $0.bottom.equalTo(self.view.safeArea.bottom)
        }
    }

}
