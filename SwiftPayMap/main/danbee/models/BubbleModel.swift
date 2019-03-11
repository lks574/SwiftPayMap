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
