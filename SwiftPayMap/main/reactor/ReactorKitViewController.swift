//
//  ReactorKitViewController.swift
//  SwiftPayMap
//
//  Created by KyungSeok Lee on 2019. 3. 6..
//  Copyright © 2019년 KyungSeok Lee. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import Then
import SnapKit

class ReactorKitViewController: UIViewController {
    
    var disposeBag: DisposeBag = DisposeBag()
    
    let decreaseButton = UIButton().then{
        $0.setTitle("-", for: .normal)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.backgroundColor = UIColor.blue
    }
    let increaseButton = UIButton().then{
        $0.setTitle("+", for: .normal)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.backgroundColor = UIColor.blue
    }
    let valueLabel = UILabel().then{
        $0.textColor = UIColor.black
    }
    let activityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        uiSetting()
        let reactors = ReactorKitReactor()
        self.reactor = reactors
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        disposeBag = DisposeBag()
    }
    
    
    
    
    private func uiSetting(){
        [decreaseButton, increaseButton, valueLabel, activityIndicatorView].forEach{
            self.view.addSubview($0)
        }
        decreaseButton.snp.makeConstraints{
            $0.centerX.equalTo(self.view).multipliedBy(0.5)
            $0.centerY.equalTo(self.view)
            $0.height.width.equalTo(40)
        }
        increaseButton.snp.makeConstraints{
            $0.centerX.equalTo(self.view).multipliedBy(1.5)
            $0.centerY.equalTo(decreaseButton)
            $0.height.width.equalTo(40)
        }
        valueLabel.snp.makeConstraints{
            $0.centerX.equalTo(self.view)
            $0.centerY.equalTo(self.view)
        }
        activityIndicatorView.snp.makeConstraints{
            $0.centerX.equalTo(self.view)
            $0.centerY.equalTo(self.view).multipliedBy(1.5)
        }
    }
}


extension ReactorKitViewController: View {

    func bind(reactor: ReactorKitReactor) {
        // Action
        increaseButton.rx.tap               // Tap event
            .map { Reactor.Action.increase }  // Convert to Action.increase
            .bind(to: reactor.action)         // Bind to reactor.action
            .disposed(by: disposeBag)
        
        decreaseButton.rx.tap
            .map { Reactor.Action.decrease }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // State
        reactor.state.map { $0.value }   // 10
            .distinctUntilChanged()
            .map { "\($0)" }               // "10"
            .bind(to: valueLabel.rx.text)  // Bind to valueLabel
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .bind(to: activityIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)

    }
}
