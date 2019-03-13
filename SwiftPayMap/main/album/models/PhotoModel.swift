//
//  PhotoModel.swift
//  SwiftPayMap
//
//  Created by KyungSeok Lee on 2019. 3. 13..
//  Copyright © 2019년 KyungSeok Lee. All rights reserved.
//

import Foundation
import Photos
import RxDataSources

struct PhotoModel {
    var image: [PHAsset]
}

extension PhotoModel : SectionModelType {
    var items: [PHAsset] {
        return self.image
    }
    init(original: PhotoModel, items: [PHAsset]) {
        self = original
        self.image = items
    }
}
