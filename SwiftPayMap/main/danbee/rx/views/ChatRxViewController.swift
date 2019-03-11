
//
//  ChatRxViewController.swift
//  SwiftPayMap
//
//  Created by KyungSeok Lee on 2019. 3. 11..
//  Copyright © 2019년 KyungSeok Lee. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxKeyboard
import RxDataSources
import RxOptional
import RxViewController

class ChatRxViewController: UIViewController {
    var disposeBag = DisposeBag()
    
    let viewModel = ChatViewModel()
    
    struct Identifier {
        static let myChatCell = "myChatCell"
        static let aiChatCell = "aiChatCell"
    }
    
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
    
    private func keyboardUpdate(hight: CGFloat){
        if hight == 0 {
            messageField.snp.updateConstraints{
                $0.bottom.equalTo(self.view.safeArea.bottom)
            }
        }else{
            messageField.snp.updateConstraints{
                $0.bottom.equalTo(self.view.snp.bottom).offset(-hight)
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
        
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] frame in
                self?.keyboardUpdate(hight: frame)
            }).disposed(by: disposeBag)
        
        sendButton.rx.tap
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
        
        
        viewModel.posts.asDriver(onErrorJustReturn: [])
            .drive(mainTableView.rx.items(dataSource: myDataSources))
            .disposed(by: disposeBag)
        
        
        viewModel.errorMessage.asObservable()
            .subscribe(onNext: { [weak self] str in
                self?.showAlertError(message: str)
            }).disposed(by: disposeBag)
    }
    
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
