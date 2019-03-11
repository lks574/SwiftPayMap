//
//  ChatViewModel.swift
//  SwiftPayMap
//
//  Created by KyungSeok Lee on 2019. 3. 11..
//  Copyright © 2019년 KyungSeok Lee. All rights reserved.
//

import Foundation
import RxSwift

class ChatViewModel {
    var disposeBag = DisposeBag()
    
    // input
    let sendMessage = PublishSubject<String>()
    
    
    // output
    let posts = BehaviorSubject<[MyBubbleCellModel]>(value: [])
    let errorMessage = PublishSubject<String>()
    
    var totalCellModels = [MyBubbleCellModel]()
    
    init(){
        DanbeeService.welcome()
            .map{BubbleModel(message: $0.result.result[0].message, postion: true, imgRoute: $0.result.result[0].imgRoute)}
            .map{[MyBubbleCellModel(items: [$0])]}
            .subscribe(onNext:{[weak self] (models) in
                self?.totalCellModels = models
                self?.posts.onNext(models)
            }).disposed(by: disposeBag)
        
        sendMessage.asObservable()
            .subscribe{ [weak self] event in
                switch event {
                case .next(let message):
                    self?.sendApi(str: message)
                    break
                case .error(let error):
                    self?.errorMessage.onNext(error.localizedDescription)
                case .completed:
                    break
                }
            }.disposed(by: disposeBag)
        
    
        
//        Observable.combineLatest(welcome.asObservable(), welcomeApi.asObservable())
//            .subscribe(onNext:{ [weak self] (_, models) in
//                self?.posts.onNext(models)
//            }, onError:{ [weak self] (error) in
//                self?.errorMessage.onNext(error.localizedDescription)
//            }).disposed(by: disposeBag)
        
//        welcome.asObservable().withLatestFrom(welcomeApi.asObservable())
//            .subscribe(onNext: { asd in
//                print(asd)
//            }).disposed(by: disposeBag)
    }

    
    private func sendApi(str: String){
        DanbeeService.engine(message: str)
            .map{ (BubbleModel(message: str, postion: false, imgRoute: nil), BubbleModel(message: $0.result.result[0].message, postion: true, imgRoute: $0.result.result[0].imgRoute))}
            .map{ (MyBubbleCellModel(items: [$0.0]), MyBubbleCellModel(items: [$0.1])) }
            .subscribe(onNext:{[weak self] (myData) in
                self?.totalCellModels.append(myData.0)
                self?.totalCellModels.append(myData.1)
                self?.posts.onNext(self?.totalCellModels ?? [])
            }).disposed(by: disposeBag)
    }
    
    
    func dispose(){
        disposeBag = DisposeBag()
    }
}
