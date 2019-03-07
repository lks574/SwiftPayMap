//
//  ChatViewController.swift
//  SwiftPayMap
//
//  Created by KyungSeok Lee on 2019. 3. 7..
//  Copyright © 2019년 KyungSeok Lee. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxOptional
import ReactorKit
import RxViewController
import Then

class ChatViewController: UIViewController {
    
    let service = DanbeeService()
    var disposeBag: DisposeBag = DisposeBag()

    
    private let messageLabel = UILabel().then{
        $0.textColor = UIColor.black
        $0.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        $0.numberOfLines = 0
        $0.textAlignment = NSTextAlignment.center
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
    
    
    private func uiSetting(){
        [messageLabel, sendButton, messageField].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview($0)
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
        
        messageLabel.snp.makeConstraints{
            $0.top.equalTo(messageField.snp.bottom).offset(20)
            $0.leading.equalTo(self.view)
            $0.trailing.equalTo(self.view)
        }
        
    }
}


extension ChatViewController: View {

    
    func bind(reactor: ChatViewReactor) {
        // Action
        rx.viewDidLoad
            .map{Reactor.Action.welcome}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.sendButton.rx.tap
            .map{[weak self] in
                self?.messageField.text
            }
            .filterNil()
            .map{Reactor.Action.sendMessage($0)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
            
//            .bind(to: reactor.action)
//            .disposed(by: disposeBag)
        
        // State
        reactor.state
            .map{$0.bubble}
            .debug()
            .filter{$0.count > 1}
            .map{ $0[1].message }
            .distinctUntilChanged()
            .bind(to: messageLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

