//
//  ChatViewController.swift
//  SwiftPayMap
//
//  Created by KyungSeok Lee on 2019. 3. 7..
//  Copyright © 2019년 KyungSeok Lee. All rights reserved.
//

import UIKit

import ReactorKit
//import ReusableKit
import RxCocoa
import RxDataSources
import RxOptional
import RxSwift

import RxViewController
import SnapKit
import Then



class ChatViewController: UIViewController {

    
    var disposeBag: DisposeBag = DisposeBag()

    // 내 채팅창 Cell
    static let myCellIndentifier = "myDanbeeCell"
    
//    struct Reusable {
//        static let myCell = ReusableCell<MyDanbeeCell>()
//    }
//
//    struct Constant {
//        static let cellIdentifier = "myCell"
//    }
    
    
    private let mainTableView = UITableView(frame: .zero, style: UITableView.Style.plain).then{
        $0.backgroundColor = UIColor.white
        
        // tableview의 높이가 컨텐츠의 크기에 따라 변경됨.
        $0.estimatedRowHeight = 80
        $0.rowHeight = UITableView.automaticDimension
        
        // 데이터 없으면 빈 공간으로
        $0.tableFooterView = UIView(frame: .zero)
        
        // 테이블뷰 cell 연결
        $0.register(MyDanbeeCell.self, forCellReuseIdentifier: myCellIndentifier)
    }
    
    // DataSources 형태는 SectionModelType 가지고 있는 객체여야된다.
    let myDataSources = RxTableViewSectionedReloadDataSource<MyBubbleCellModel>(configureCell: {(dataSource, tableView, indexPath, item) in
        let cell = tableView.dequeueReusableCell(withIdentifier: myCellIndentifier, for: indexPath) as! MyDanbeeCell
        cell.myMessage.text = item.message
        return cell
    })

    
    private let sendButton = UIButton().then{
        $0.setTitle("보내기", for: .normal)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.backgroundColor = UIColor.blue
    }
    private let messageField = UITextField().then{
        $0.textColor = UIColor.black
        $0.placeholder = "message"
        $0.borderStyle = UITextField.BorderStyle.roundedRect
    }
    
    init(reactor: ChatViewReactor){
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        uiSetting()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        disposeBag = DisposeBag()
    }

    
    
    private func uiSetting(){
        [mainTableView, sendButton, messageField].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview($0)
        }
        mainTableView.snp.makeConstraints{
            $0.top.equalTo(messageField.snp.bottom).offset(20)
            $0.leading.equalTo(self.view)
            $0.trailing.equalTo(self.view)
            $0.bottom.equalTo(self.view.safeArea.bottom)
        }
        messageField.snp.makeConstraints{
            $0.top.equalTo(self.view.safeArea.top).offset(8)
            $0.centerX.equalTo(self.view)
            $0.width.equalTo(self.view).multipliedBy(0.7)
            $0.width.height.equalTo(40)
        }
        sendButton.snp.makeConstraints{
            $0.centerY.equalTo(messageField)
            $0.leading.equalTo(messageField.snp.trailing)
        }

    }
}


extension ChatViewController: ReactorKit.View {

    
    func bind(reactor: ChatViewReactor) {
        // DataSource
        self.mainTableView.rx.modelSelected(BubbleModel.self).subscribe(onNext: { bubble in
            let vc = DaumViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
        
        // Action
        rx.viewDidLoad
            .map{Reactor.Action.welcome}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        
        self.sendButton.rx.tap
            // 클릭 후 중복 제거
            .throttle(2, scheduler: MainScheduler.instance)
            .map{[weak self] in
                self?.messageField.text
            }
            .filterNil()
            .map{Reactor.Action.sendMessage($0)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        
        
        // State
        reactor.state
            .map{$0.bubbles}
            .replaceNilWith([])
            .debug()
            // 테이블뷰와 바인딩하기 위해서는 dataSource 의 모델 형태의 배열이 있어야된다.
            .bind(to: mainTableView.rx.items(dataSource: myDataSources))
            .disposed(by: disposeBag)
        

    }
}

