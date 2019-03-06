//
//  Photos.swift
//  SwiftPayMap
//
//  Created by KyungSeok Lee on 2019. 3. 6..
//  Copyright © 2019년 KyungSeok Lee. All rights reserved.
//

import RxDataSources

struct Photos {
    var photos: [Photo]
}

extension Photos: SectionModelType {
    var items: [Photo] {
        return self.photos
    }
    init(original: Photos, items: [Photo]) {
        self = original
        self.photos = items
    }
}
