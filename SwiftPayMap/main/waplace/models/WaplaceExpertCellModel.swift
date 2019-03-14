//
//  WaplaceExpertCellModel.swift
//  SwiftPayMap
//
//  Created by KyungSeok Lee on 2019. 3. 14..
//  Copyright © 2019년 KyungSeok Lee. All rights reserved.
//

import Foundation
import RxDataSources

struct WaplaceExpertCellModel {
    var item: [WaplaceExpertModel]
}

extension WaplaceExpertCellModel : SectionModelType {
    var items: [WaplaceExpertModel] {
        return self.item
    }
    init(original: WaplaceExpertCellModel, items: [WaplaceExpertModel]) {
        self = original
        self.item = items
    }
}


struct WaplaceExpertModel {
    let title: String
    let imageStr: String
    let buisnessType: String
    let UsageType: String
    let cido: String
    let explanation: String
    let career: String
    let favorite: String
    let review: String
}
