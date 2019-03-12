//
//  BubbleModel.swift
//  SwiftPayMap
//
//  Created by KyungSeok Lee on 2019. 3. 7..
//  Copyright © 2019년 KyungSeok Lee. All rights reserved.
//

import RxDataSources

// Cell Data
struct BubbleModel {
    let message: String
    let postion: Bool
    let imgRoute: String?
    let options : [BubbleOption]?
    
    init(message: String, postion: Bool){
        self.message = message
        self.postion = postion
        self.imgRoute = nil
        self.options = nil
    }
    
    init(apiModel: ResponseSetApi, postion: Bool) {
        self.message = apiModel.result.result[0].message
        self.postion = postion
        self.imgRoute = apiModel.result.result[0].imgRoute
        self.options = apiModel.result.result[0].optionList.map{BubbleOption(apiModel: $0)}
    }
}

struct BubbleOption {
    let id: String
    let type: String
    let value: String
    let label: String
    
    init(apiModel: DanbeeOptionList){
        self.id = apiModel.id
        self.type = apiModel.type
        self.value = apiModel.value
        self.label = apiModel.label
    }
}

// tableView에 바인딩
struct MyBubbleCellModel {
    
    // table의 데이터 (당연히 list형태)
    var items: [BubbleModel]
}
extension MyBubbleCellModel: SectionModelType {
    typealias Item = BubbleModel
    
    init(original: MyBubbleCellModel, items: [Item]) {
        self = original
        self.items = items
    }
}
