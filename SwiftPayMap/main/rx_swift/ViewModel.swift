//
//  ViewModel.swift
//  SwiftPayMap
//
//  Created by KyungSeok Lee on 2019. 3. 5..
//  Copyright © 2019년 KyungSeok Lee. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class ViewModel {
    
    var disposed = DisposeBag()
    
    let idInputText: BehaviorSubject<String> = BehaviorSubject(value: "")
    let idValid : BehaviorSubject<Bool> = BehaviorSubject(value: false)
    let pwInputText: BehaviorSubject<String> = BehaviorSubject(value: "")
    let pwValid : BehaviorSubject<Bool> = BehaviorSubject(value: false)
    
    
    func dispose(){
        disposed = DisposeBag()
    }
}
