//
//  ChatViewReactor.swift
//  SwiftPayMap
//
//  Created by KyungSeok Lee on 2019. 3. 7..
//  Copyright © 2019년 KyungSeok Lee. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift

class ChatViewReactor: Reactor {

    enum Action{
        case welcome
        case sendMessage(String)
    }
    
    enum Mutation{
        case message(BubbleModel)
        case myMessage(BubbleModel)
    }
    
    struct State {
        var bubble: [BubbleModel] = []
    }

    let initialState: ChatViewReactor.State
    
    init(){
        initialState = State()
        
    }
    
    
    // Action -> Mutation
    func mutate(action: ChatViewReactor.Action) -> Observable<ChatViewReactor.Mutation> {
        switch action {
        case .welcome:
            return DanbeeService.welcome()
                .map{ BubbleModel(message: $0.result.result[0].message, postion: true) }
                .map{Mutation.message($0)}
        case .sendMessage(let message):
            return Observable.concat(
//                Observable<ChatViewReactor.Mutation>.create{ observer in
//                    .map{ BubbleModel(message: message, postion: true) }
//                        .map{ Mutation.myMessage($0) }
//                },
//                DanbeeService.engine(message: message)
//                    .map{ _ in BubbleModel(message: message, postion: false) }
//                    .map{Mutation.myMessage($0)},
                 DanbeeService.engine(message: message)
                    .map{ BubbleModel(message: $0.result.result[0].message, postion: true) }
                    .map{Mutation.myMessage($0)}
            )
            
            
        }
    }
    
    
    // Mutation -> State
    func reduce(state: ChatViewReactor.State, mutation: ChatViewReactor.Mutation) -> ChatViewReactor.State {
        var newState = state
        switch mutation {
        case let .message(bubble):
//            if let serch = bubble.serchMessage {
//                newState.bubble.append(BubbleModel.init(serchMessage: serch, message: bubble.message, postion: false))
//            }
            newState.bubble.append(bubble)
        
        case let .myMessage(myBubble):
            newState.bubble.append(myBubble)
        }
        return newState
    }
    
}
