//
//  WaplaceMainTableModel.swift
//  SwiftPayMap
//
//  Created by KyungSeok Lee on 2019. 3. 14..
//  Copyright © 2019년 KyungSeok Lee. All rights reserved.
//

import Foundation
import RxDataSources

struct WaplaceMainTableModel {
    var titleStr: [String]
}

extension WaplaceMainTableModel : SectionModelType {
    var items: [String] {
        return self.titleStr
    }
    init(original: WaplaceMainTableModel, items: [String]) {
        self = original
        self.titleStr = items
    }
}
