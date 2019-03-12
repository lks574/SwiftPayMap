//
//  AlbumViewModel.swift
//  SwiftPayMap
//
//  Created by KyungSeok Lee on 2019. 3. 12..
//  Copyright © 2019년 KyungSeok Lee. All rights reserved.
//

import Foundation
import RxSwift

class AlbumViewModel {
    var disposeBag = DisposeBag()
    
    
    
    
    func dispose(){
        disposeBag = DisposeBag()
    }
    
    deinit {
        dispose()
    }
}
