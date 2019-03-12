//
//  AlbumViewController.swift
//  SwiftPayMap
//
//  Created by KyungSeok Lee on 2019. 3. 12..
//  Copyright © 2019년 KyungSeok Lee. All rights reserved.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import RxDataSources
import Photos

class AlbumViewController: UIViewController {
    var disposeBag = DisposeBag()
    
    struct Identifier {
        static let albumIdentifier = "albumCell"
    }
    
    var allPhotos: PHFetchResult<PHAsset>?
    var images = [UIImage]()
    
    let viewModel = AlbumViewModel()


    var photo = UIImage()
    
    let albumCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout()).then{
        $0.register(AlbumCollectionViewCell.self, forCellWithReuseIdentifier: Identifier.albumIdentifier)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.allPhotos = PHAsset.fetchAssets(with: nil)
        uiSetting()
        binding()
        etcSetting()
        fetchCustomAlbumPhotos()
    }
    
    private func etcSetting(){
        
    }
    
    private func binding(){
        let dataSources = RxCollectionViewSectionedReloadDataSource<Photos>(configureCell: { (dataSource, collectionView, indexPath, item) -> UICollectionViewCell in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifier.albumIdentifier, for: indexPath) as! AlbumCollectionViewCell
            cell.mainImageView.image = self.images[indexPath.item]
//            if let imageURL = item.flickrURL(), let url = URL(string: imageURL){
//                cell.flickrPhoto.kf.setImage(with: url)
//            }
            return cell
        })
        
        albumCollectionView.rx.setDataSource(dataSources).disposed(by: disposeBag)
        albumCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
    }
    
    func fetchCustomAlbumPhotos()
    {
        let albumName = "Album Name Here"
        var assetCollection = PHAssetCollection()
        var albumFound = Bool()
        var photoAssets = PHFetchResult<AnyObject>()
        let fetchOptions = PHFetchOptions()
        
        fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
        let collection:PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        
        if let firstObject = collection.firstObject{
            //found the album
            assetCollection = firstObject
            albumFound = true
        }
        else { albumFound = false }
        _ = collection.count
        photoAssets = PHAsset.fetchAssets(in: assetCollection, options: nil) as! PHFetchResult<AnyObject>
        let imageManager = PHCachingImageManager()
        photoAssets.enumerateObjects{(object: AnyObject!,
            count: Int,
            stop: UnsafeMutablePointer<ObjCBool>) in
            
            if object is PHAsset{
                let asset = object as! PHAsset
                print("Inside  If object is PHAsset, This is number 1")
                
                let imageSize = CGSize(width: asset.pixelWidth,
                                       height: asset.pixelHeight)
                
                /* For faster performance, and maybe degraded image */
                let options = PHImageRequestOptions()
                options.deliveryMode = .fastFormat
                options.isSynchronous = true
                
                imageManager.requestImage(for: asset,targetSize: imageSize, contentMode: .aspectFill, options: options, resultHandler: {( image, info) -> Void in
                    print(image)
                    self.photo = image!
                    /* The image is now available to us */
                    self.addImgToArray(uploadImage: self.photo)
                    print("enum for image, This is number 2")
                                            
                })
                
            }
        }
    }
    
    func addImgToArray(uploadImage:UIImage)
    {
        self.images.append(uploadImage)
        
    }
    
    private func uiSetting(){
        [albumCollectionView].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview($0)
        }
        albumCollectionView.snp.makeConstraints{
            $0.top.equalTo(self.view.safeArea.top)
            $0.leading.equalTo(self.view)
            $0.trailing.equalTo(self.view)
            $0.bottom.equalTo(self.view.safeArea.bottom)
        }
    }
}

extension AlbumViewController : UICollectionViewDelegateFlowLayout {
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}
