//
//  PhotoListViewReactor.swift
//  SwiftPayMap
//
//  Created by KyungSeok Lee on 2019. 3. 6..
//  Copyright © 2019년 KyungSeok Lee. All rights reserved.
//

import ReactorKit
import RxSwift
import RxCocoa

class PhotoListViewReactor : Reactor {
    enum Action {
        case searchFlickr(String)
    }
    
    enum Mutation {
        case flickrList([Photos])
    }
    
    struct State {
        var photos: [Photos]?
    }
    
    var initialState: State = State()
    
    init() {}
    
    func mutate(action: PhotoListViewReactor.Action) -> Observable<PhotoListViewReactor.Mutation> {
        switch action {
        case let .searchFlickr(keyword):
            return AppService.request(keyword: keyword)
                .catchErrorJustReturn([])
                .map{[Photos(photos: $0)]}
                .map{Mutation.flickrList($0)}
        }
    }
    
    func reduce(state: PhotoListViewReactor.State, mutation: PhotoListViewReactor.Mutation) -> PhotoListViewReactor.State {
        var newState = state
        switch mutation {
        case let .flickrList(photos):
            newState.photos = photos
        }
        return newState
    }
}
