//
//  ChatViewController.swift
//  SwiftPayMap
//
//  Created by KyungSeok Lee on 2019. 3. 7..
//  Copyright © 2019년 KyungSeok Lee. All rights reserved.
//

import UIKit

import Kingfisher
import ReactorKit
//import ReusableKit
import RxCocoa
import RxDataSources
import RxOptional
import RxSwift
import RxKeyboard

import RxViewController
import SnapKit
import Then



class ChatViewController: UIViewController {

    
    var disposeBag: DisposeBag = DisposeBag()

    // 내 채팅창 Cell
    static let myCellIndentifier = "myDanbeeCell"
    static let aiCellIndentifier = "aiDanbeeCell"
    
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
        $0.register(AiDanbeeCell.self, forCellReuseIdentifier: aiCellIndentifier)
        
        $0.separatorStyle = .none
    }
    
    // DataSources 형태는 SectionModelType 가지고 있는 객체여야된다.
    let myDataSources = RxTableViewSectionedReloadDataSource<MyBubbleCellModel>(configureCell: {(dataSource, tableView, indexPath, item) in
        
        if item.postion {
            let cell = tableView.dequeueReusableCell(withIdentifier: aiCellIndentifier, for: indexPath) as! AiDanbeeCell
            cell.selectionStyle = .none
            cell.myMessage.text = item.message
            if let mainImage = item.imgRoute {
                
                // 이미지를 다운 받고 cell의 크기를 조정하기 위해
                cell.mainImageView.kf.setImage(with: URL(string: mainImage), completionHandler: { (_) in
                    cell.setNeedsLayout()
                    
                    UIView.performWithoutAnimation {
                        tableView.beginUpdates()
                        tableView.endUpdates()
                    }
                })
                
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: myCellIndentifier, for: indexPath) as! MyDanbeeCell
            cell.selectionStyle = .none
            cell.messageLabel.text = item.message
            return cell
        }
        
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
        self.navigationItem.title = "단비 AI 채팅"
        self.view.backgroundColor = UIColor.white
        uiSetting()
        
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] frame in
                self?.keyboardUpdate(hight: frame)
            }).disposed(by: disposeBag)
    }
    
    
    private func keyboardUpdate(hight: CGFloat){
        messageField.snp.updateConstraints{
            $0.bottom.equalTo(self.view.safeArea.bottom).offset(-hight)
        }
    }
    
//    private func tableViewScrollBottom(){
//        if (mainTableView.contentSize.height > mainTableView.frame.size.height){
//
//            let Point = CGPoint(x: 0, y:  mainTableView.contentSize.height - mainTableView.frame.size.height)
//            mainTableView.setContentOffset(Point, animated: true)
//        }
//    }

    
    
    private func uiSetting(){
        [mainTableView, sendButton, messageField].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview($0)
        }
        mainTableView.snp.makeConstraints{
            $0.top.equalTo(self.view.safeArea.top).offset(10)
            $0.leading.equalTo(self.view)
            $0.trailing.equalTo(self.view)
        }
        messageField.snp.makeConstraints{
            $0.top.equalTo(mainTableView.snp.bottom)
            $0.bottom.equalTo(self.view.safeArea.bottom)
            $0.leading.equalTo(self.view)
            $0.height.equalTo(40)
            $0.width.equalTo(self.view).multipliedBy(0.8)
        }
        sendButton.snp.makeConstraints{
            $0.centerY.equalTo(messageField)
            $0.leading.equalTo(messageField.snp.trailing)
            $0.trailing.equalTo(self.view)
        }

    }
}


extension ChatViewController: ReactorKit.View {

    func bind(reactor: ChatViewReactor) {
        // DataSource
        self.mainTableView.rx.modelSelected(BubbleModel.self).subscribe(onNext: {[weak self] bubble in
            let vc = DaumViewController()
            self?.navigationController?.pushViewController(vc, animated: true)
            self?.messageField.resignFirstResponder()
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
            .do(onNext: { [weak self]  _ in
                self?.messageField.resignFirstResponder()
            })
            .map{Reactor.Action.sendMessage($0)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        
        // State
        reactor.state
            .map{$0.bubbles}
            .replaceNilWith([])
            .debug()
            .do(onNext: { [weak self]  asd in
                self?.messageField.text = nil
//                self?.tableViewScrollBottom()
            })
            // 테이블뷰와 바인딩하기 위해서는 dataSource 의 모델 형태의 배열이 있어야된다.
            .bind(to: mainTableView.rx.items(dataSource: myDataSources))
            .disposed(by: disposeBag)
        

    }
}

