//
//  DanbeeService.swift
//  SwiftPayMap
//
//  Created by KyungSeok Lee on 2019. 3. 7..
//  Copyright © 2019년 KyungSeok Lee. All rights reserved.
//

import Moya
import RxSwift
import SwiftyJSON

class DanbeeService {
    static let provider = MoyaProvider<DanbeeMoya>()
//    var disposeBag = DisposeBag()
    
    static func welcome() -> Observable<ResponseSetApi> {
        return Observable.create { observer -> Disposable in
            self.provider.request(.welcome) { (result) in
                switch result{
                case .success(let response):
                    do{
                        let filteredResponse = try response.filterSuccessfulStatusCodes()
                        print(try filteredResponse.mapJSON())
                        let responseModel = try filteredResponse.map(ResponseSetApi.self, atKeyPath: "responseSet")
                        observer.onNext(responseModel)
                    }catch let error {
                        observer.onError(error)
                    }
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    
    static func engine(message: String) -> Observable<ResponseSetApi> {
        return Observable.create { observer -> Disposable in
            self.provider.request(.engine(message)) { (result) in
                switch result{
                case .success(let response):
                    do{
                        let filteredResponse = try response.filterSuccessfulStatusCodes()
                        print(try filteredResponse.mapJSON())
                        
                        let responseModel = try filteredResponse.map(ResponseSetApi.self, atKeyPath: "responseSet")
                        observer.onNext(responseModel)
                    }catch let error {
                        observer.onError(error)
                    }
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}
