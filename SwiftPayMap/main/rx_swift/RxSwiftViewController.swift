//
//  RxSwiftViewController.swift
//  SwiftPayMap
//
//  Created by KyungSeok Lee on 2019. 3. 5..
//  Copyright © 2019년 KyungSeok Lee. All rights reserved.
//

// ObserVable : 관찰 가능한 subscriberk 가능
// subject : 외부에서 넣어줄수도 있고 subscribe도 가능한 ObserVable

import UIKit
import RxCocoa
import RxSwift
import Then

class RxSwiftViewController: BaseViewController {

    let viewModel = ViewModel()
    
    let idInputText: BehaviorSubject<String> = BehaviorSubject(value: "")
    let idValid : BehaviorSubject<Bool> = BehaviorSubject(value: false)
    let pwInputText: BehaviorSubject<String> = BehaviorSubject(value: "")
    let pwValid : BehaviorSubject<Bool> = BehaviorSubject(value: false)
    
    
    private let idField = UITextField().then{
        $0.textColor = UIColor.black
        $0.placeholder = "아이디"
        $0.borderStyle = UITextField.BorderStyle.roundedRect
    }
    private let pwField = UITextField().then{
        $0.textColor = UIColor.black
        $0.placeholder = "비밀번호"
        $0.isSecureTextEntry = true
        $0.borderStyle = UITextField.BorderStyle.roundedRect
    }
    private let okButton = UIButton().then{
        $0.setTitle("로그인", for: .normal)
        $0.setTitle("아이디 비밀번호 확인", for: .disabled)
        $0.isEnabled = false
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.setTitleColor(UIColor.white, for: .disabled)
        $0.backgroundColor = UIColor.blue
    }
    
    private let idValidView = UIView().then{
        $0.backgroundColor = UIColor.red
    }
    
    private let pwValidView = UIView().then{
        $0.backgroundColor = UIColor.red
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        uiSetting()
        etcSetting()
        
        bindInput()
        bindOutput()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.dispose()
    }
    
    
    @objc private func loginButton(_ sender: UIButton){
        let alert = UIAlertController(title: "로그인", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    private func bindInput(){
        // id input +--> check valid --> bullet
        //          |
        //          +--> button enable
        //          |
        //          +--> check valid --> bullet
        
        // input : 아이디입력, 비번 입력
        idField.rx.text.orEmpty
            .bind(to: idInputText)
            .disposed(by: viewModel.disposed)
        
        idInputText.map(checkEmailValid)
            .bind(to: idValid)
            .disposed(by: viewModel.disposed)
//        let idValidOb = idInputOb.map(checkEmailValid)
//        idValidOb.bind(to: idValid)
        
//        // bind 를 길게 쓴것
//        idValidOb.subscribe(onNext:{ b in
//            self.idValid.onNext(b)
//        })
        
        pwField.rx.text.orEmpty
            .bind(to: pwInputText)
            .disposed(by: viewModel.disposed)
        
        pwInputText.map(checkPasswordValid)
            .bind(to: pwValid)
            .disposed(by: viewModel.disposed)
    }
    
    private func bindOutput(){
        
        // output : 블릿, 로그인버튼 상태 변경
        idValid.subscribe(onNext:{ self.idValidView.isHidden = $0})
            .disposed(by: viewModel.disposed)
        pwValid.subscribe(onNext:{self.pwValidView.isHidden = $0})
            .disposed(by: viewModel.disposed)
        
        Observable.combineLatest(idValid, pwValid) { $0 && $1 }
            .subscribe(onNext:{self.okButton.isEnabled = $0})
            .disposed(by: viewModel.disposed)
        
        
        
//        idField.rx.text.orEmpty
//            .map(checkEmailValid)
//            .subscribe(onNext:{ b in
//                self.idValidView.isHidden = b
//            }).disposed(by: disposeBag)
//
//
//        pwField.rx.text.orEmpty
//            .map(checkPasswordValid)
//            .subscribe(onNext:{ b in
//                self.pwValidView.isHidden = b
//            }).disposed(by: disposeBag)
//
//        Observable.combineLatest(
//            idField.rx.text.orEmpty.map(checkEmailValid),
//            pwField.rx.text.orEmpty.map(checkPasswordValid)) {s1, s2 in s1 && s2}
//            .subscribe(onNext:{ b in
//                self.okButton.isEnabled = b
//            }).disposed(by: disposeBag)
//
////         축소 전 1
////        Observable.combineLatest(idField.rx.text.orEmpty.map(checkEmailValid),
////                                 pwField.rx.text.orEmpty.map(checkPasswordValid)) { (s1, s2) -> Bool in
////            s1 && s2
////        }.subscribe().dispose()
////
////         축소 전 2
////        Observable.combineLatest(idField.rx.text.orEmpty.map(checkEmailValid), pwField.rx.text.orEmpty.map(checkPasswordValid), resultSelector: {s1, s2 in s1 && s2})
////        .subscribe().disposed(by: disposeBag)
    }
    
    
    private func checkEmailValid(_ email: String) -> Bool {
        return email.contains("@") && email.contains(".")
    }
    
    private func checkPasswordValid(_ password: String) -> Bool {
        return password.count > 6
    }
    
    
    private func etcSetting(){
        okButton.addTarget(self, action: #selector(loginButton(_:)), for: .touchUpInside)
    }
    
    
    private func uiSetting(){
        [idField, pwField, okButton, idValidView, pwValidView].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = true
            self.view.addSubview($0)
        }
        
        idField.snp.makeConstraints{
            $0.top.equalTo(self.safeTop()).offset(20)
//            $0.height.equalTo(60)
            $0.centerX.equalTo(self.view)
            $0.width.equalTo(self.view).multipliedBy(0.7)
        }
        
        
        idValidView.snp.makeConstraints{
            $0.top.equalTo(idField)
            $0.trailing.equalTo(idField)
            $0.width.height.equalTo(20)
        }
        idValidView.layer.cornerRadius = 10
        
        pwField.snp.makeConstraints{
            $0.top.equalTo(idField.snp.bottom).offset(10)
//            $0.height.equalTo(idField.snp.height)
            $0.centerX.equalTo(idField)
            $0.width.equalTo(idField)
        }
        
        pwValidView.snp.makeConstraints{
            $0.top.equalTo(pwField)
            $0.trailing.equalTo(pwField)
            $0.width.height.equalTo(20)
        }
        pwValidView.layer.cornerRadius = 10
        
        okButton.snp.makeConstraints{
            $0.top.equalTo(pwField.snp.bottom).offset(20)
            $0.centerX.equalTo(idField)
            $0.width.equalTo(idField)
        }
        
        
    }
}
