//
//  PHAsset+Extension.swift
//  SwiftPayMap
//
//  Created by KyungSeok Lee on 2019. 3. 14..
//  Copyright © 2019년 KyungSeok Lee. All rights reserved.
//

import Foundation
import Photos

extension PHAsset {
    var originalFilename: String? {
        return PHAssetResource.assetResources(for: self).first?.originalFilename
    }
    
    
}
