//
//  ChatViewReactor.swift
//  SwiftPayMap
//
//  Created by KyungSeok Lee on 2019. 3. 7..
//  Copyright © 2019년 KyungSeok Lee. All rights reserved.
//

import Foundation
import RxOptional
import ReactorKit
import RxSwift

class ChatViewReactor: Reactor {

    enum Action{
        case welcome
        case sendMessage(String)
    }
    
    enum Mutation{
        case message(BubbleModel, Bool)     // welcome인 경우에만 true (최초에 값을 넣기 위해)
        case myMessage(BubbleModel)
    }
    
    struct State {
        // table 바인딩
        // SectionModelType 확장해야되며, 배열 형태(section 으로 되어있기 때문)
        var bubbles: [MyBubbleCellModel]?
    }

    let initialState: ChatViewReactor.State = State()
    
    init(){}
    
    
    // Action -> Mutation
    func mutate(action: ChatViewReactor.Action) -> Observable<ChatViewReactor.Mutation> {
        switch action {
        case .welcome:
            return DanbeeService.welcome()
                .map{ BubbleModel(message: $0.result.result[0].message, postion: true) }
                .map{Mutation.message($0, true)}
        case .sendMessage(let message):
            return Observable.concat(
                Observable.just(Mutation.myMessage(BubbleModel(message: message, postion: false))),
                DanbeeService.engine(message: message)
                    .map{ BubbleModel(message: $0.result.result[0].message, postion: true) }
                    .map{Mutation.message($0, false)}
            )
        }
    }
    
    
    // Mutation -> State
    func reduce(state: ChatViewReactor.State, mutation: ChatViewReactor.Mutation) -> ChatViewReactor.State {
        var newState = state
        switch mutation {
        case let .message(bubble):
//            let bubble = newState.bubbles!
            if bubble.1 {
                newState.bubbles = [MyBubbleCellModel(items: [bubble.0])]
                break
            }
            if let firstSection = newState.bubbles, let first = firstSection.first {
                var bubbleModels = first.items
                bubbleModels.append(bubble.0)
                newState.bubbles = [MyBubbleCellModel(items: bubbleModels)]
            }
//            if let serch = bubble.serchMessage {
//                newState.bubble.append(BubbleModel.init(serchMessage: serch, message: bubble.message, postion: false))
//            }
//            newState.bubbles?.append(bubble)
        
        case let .myMessage(myBubble):
            if let firstSection = newState.bubbles, let first = firstSection.first {
                var bubbleModels = first.items
                bubbleModels.append(myBubble)
                newState.bubbles = [MyBubbleCellModel(items: bubbleModels)]
            }
//            newState.bubbles?.append(myBubble)
        }
        return newState
    }
    
}
