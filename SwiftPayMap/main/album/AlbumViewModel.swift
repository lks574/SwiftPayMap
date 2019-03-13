//
//  AlbumViewModel.swift
//  SwiftPayMap
//
//  Created by KyungSeok Lee on 2019. 3. 12..
//  Copyright © 2019년 KyungSeok Lee. All rights reserved.
//

import Foundation
import Photos
import RxSwift

class AlbumViewModel {
    let imageManager = PHCachingImageManager()
    var disposeBag = DisposeBag()
    
    //input
    let didLoad = PublishSubject<Void>()
    
    
    // output
    let posts = BehaviorSubject<[PhotoModel]>(value: [])
    
    init(){
        
        didLoad.asObservable()
            .subscribe(onNext:{
                self.posts.onNext(CustomPhotoAlbum.allImage(sort: "creationDate"))
            }).disposed(by: disposeBag)
    }
    
    func dispose(){
        disposeBag = DisposeBag()
    }
    
    
    deinit {
        dispose()
    }
}
