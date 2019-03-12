
//
//  ChatRxViewController.swift
//  SwiftPayMap
//
//  Created by KyungSeok Lee on 2019. 3. 11..
//  Copyright © 2019년 KyungSeok Lee. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxKeyboard
import RxDataSources
import RxOptional
import RxViewController

class ChatRxViewController: UIViewController {
    var disposeBag = DisposeBag()
    
    let viewModel = ChatViewModel()
    
    var constraint: Constraint!
    
    struct Identifier {
        static let myChatCell = "myChatCell"
        static let aiChatCell = "aiChatCell"
    }
    private let messageView = UIView()
    
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
    
    // DataSources 형태는 SectionModelType 가지고 있는 객체여야된다.
    let myDataSources = RxTableViewSectionedReloadDataSource<MyBubbleCellModel>(configureCell:  { (dataSource, tableView, indexPath, item) in
        
        if item.postion {
            let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.aiChatCell, for: indexPath) as! AiDanbeeCell
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
            let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.myChatCell, for: indexPath) as! MyDanbeeCell
            cell.selectionStyle = .none
            cell.messageLabel.text = item.message
            return cell
        }
        
    })
    
    private let mainTableView = UITableView(frame: .zero, style: UITableView.Style.plain).then{
        $0.backgroundColor = UIColor.white
        
        // tableview의 높이가 컨텐츠의 크기에 따라 변경됨.
        $0.estimatedRowHeight = 80
        $0.rowHeight = UITableView.automaticDimension
        
        // 데이터 없으면 빈 공간으로
        $0.tableFooterView = UIView(frame: .zero)
        
        // 테이블뷰 cell 연결
        $0.register(MyDanbeeCell.self, forCellReuseIdentifier: Identifier.myChatCell)
        $0.register(AiDanbeeCell.self, forCellReuseIdentifier: Identifier.aiChatCell)
        
        $0.separatorStyle = .none
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "단비 AI 채팅"
        self.view.backgroundColor = UIColor.white
        uiSetting()
        bindSetting()
    }
    
    // Rx 키보드를 통해 키보드 높이를 가져옴.
    private func keyboardUpdate(hight: CGFloat){
        if hight == 0 {
            constraint.update(offset: 0)
        }else{
            
            // safearea로 묶여 있기 때문에 올라올 경우 빼줘아된다.
            if #available(iOS 11.0, *) {
                constraint?.update(offset: -hight + view.safeAreaInsets.bottom)
            } else {
                constraint?.update(offset: -hight)
            }
        }
        

    }
    
    // alertView 보여주기
    private func showAlertError(message: String){
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    private func bindSetting(){
        
        // tableView select (rx메소드가 여러개. model로 받을수도 있고 index로 받을수도 있다)
        mainTableView.rx.itemSelected
            .subscribe(onNext:{ [weak self] (_) in
                self?.messageField.resignFirstResponder()
            }).disposed(by: disposeBag)
        
        // 키보드 라이브러리
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] frame in
                self?.keyboardUpdate(hight: frame)
            }).disposed(by: disposeBag)
        
        // send버튼과 키보드의 리턴 버튼을 merge ==> 같은 기능일 경우 combination을 찾아보자
        Observable.merge(messageField.rx.controlEvent([.editingDidEndOnExit]).asObservable(), sendButton.rx.tap.asObservable())
            .throttle(2, scheduler: MainScheduler.instance)
            .map{ [weak self] in
                self?.messageField.text
            }
            .filterNil()
            .do(onNext: { [weak self] _ in
                self?.messageField.resignFirstResponder()
                self?.messageField.text = ""
            })
            .bind(to: viewModel.sendMessage)
            .disposed(by: disposeBag)
        
        // driver : ui(매인쓰레드)에서 사용되는 경우 사용
        viewModel.posts.asDriver(onErrorJustReturn: [])
            .drive(mainTableView.rx.items(dataSource: myDataSources))
            .disposed(by: disposeBag)
        
        
        // 모든 에러인 경우 알림창 띄우기
        viewModel.errorMessage.asObservable()
            .subscribe(onNext: { [weak self] str in
                self?.showAlertError(message: str)
            }).disposed(by: disposeBag)
    }
    
    private func uiSetting(){
        [mainTableView, messageView].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview($0)
        }
        
        [sendButton, messageField].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            messageView.addSubview($0)
        }
        mainTableView.snp.makeConstraints{
            $0.top.equalTo(self.view.safeArea.top).offset(10)
            $0.leading.equalTo(self.view)
            $0.trailing.equalTo(self.view)
        }
        messageView.snp.makeConstraints{
            $0.top.equalTo(mainTableView.snp.bottom)
            $0.leading.equalTo(self.view)
            $0.trailing.equalTo(self.view)
            constraint = $0.bottom.equalTo(self.view.safeArea.bottom).constraint
        }
        messageField.snp.makeConstraints{
            $0.top.equalTo(messageView)
            $0.leading.equalTo(messageView)
            $0.height.equalTo(40)
            $0.width.equalTo(messageView).multipliedBy(0.8)
        }
        sendButton.snp.makeConstraints{
            $0.top.equalTo(messageView)
            $0.leading.equalTo(messageField.snp.trailing)
            $0.trailing.equalTo(messageView)
            $0.bottom.equalTo(messageView)
        }
    }
}
