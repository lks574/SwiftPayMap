//
//  CustomPhotoAlbum.swift
//  SwiftPayMap
//
//  Created by KyungSeok Lee on 2019. 3. 13..
//  Copyright © 2019년 KyungSeok Lee. All rights reserved.
//

import Foundation
import Photos
import RxSwift

class CustomPhotoAlbum {
//    static let albumName = "Album"
//    static let sharedInstance = CustomPhotoAlbum()
//    
//    var assetCollection: PHAssetCollection!
//
//    init(){
//        func fetchAssetCollectionForAlbum() -> PHAssetCollection! {
//            let fetchOptions = PHFetchOptions()
//            fetchOptions.predicate = NSPredicate(format: "title = %@", CustomPhotoAlbum.albumName)
//            let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
//            if let firstObject = collection.firstObject {
//                return firstObject
//            }
//            return nil
//        }
//
//        if let assetCollection = fetchAssetCollectionForAlbum() {
//            self.assetCollection = assetCollection
//            return
//        }
//
//        PHPhotoLibrary.shared().performChanges({
//            PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: CustomPhotoAlbum.albumName)
//        }) { (success, error) in
//            if let error  = error {
//                print(error.localizedDescription)
//            }
//            if success {
//                self.assetCollection = fetchAssetCollectionForAlbum()
//            }
//        }
//    }
//
//    func saveImage(image: UIImage){
//        if assetCollection == nil {
//            return
//        }
//        PHPhotoLibrary.shared().performChanges({
//            let assetChangeRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
//            let assetPlaceholder = assetChangeRequest.placeholderForCreatedAsset
//            let albumChangeRequest = PHAssetCollectionChangeRequest(for: self.assetCollection)
//            albumChangeRequest?.addAssets([assetPlaceholder] as NSFastEnumeration)
//        }, completionHandler: nil)
//    }
    
    
    static func allImage(sort: String) -> [PhotoModel]{

        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: sort, ascending: true)]
        let fetch = PHAsset.fetchAssets(with: allPhotosOptions)
        let assets: [PHAsset] = (0...fetch.count-1).map{fetch.object(at: $0)}
        
        return [PhotoModel(image:assets)]
    }
}
