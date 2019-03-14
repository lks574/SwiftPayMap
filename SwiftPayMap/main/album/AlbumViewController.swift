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
import RxViewController
import RxDataSources
import Photos

class AlbumViewController: UIViewController {
    var disposeBag = DisposeBag()
    let imageManager = PHCachingImageManager()
    
    struct Identifier {
        static let albumIdentifier = "albumCell"
    }
    struct Metric {
        static let lineSpacing: CGFloat = 10
        static let intetItemSpacing: CGFloat = 10
        static let edgeInset: CGFloat = 8
    }

    
    let viewModel = AlbumViewModel()

    
    let albumCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then{
        $0.backgroundColor = UIColor.white
        $0.register(AlbumCollectionViewCell.self, forCellWithReuseIdentifier: Identifier.albumIdentifier)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "앨범"
        
        
        
        uiSetting()
        binding()

//        fetchCustomAlbumPhotos()

        
//        getAlbum(title: "Album") { [weak self] assetCollection in
//            guard let this = self else { return }
//            guard assetCollection != nil else { return }
//            print(assetCollection!)
//        }
    }
    
    
   
    
//    func getAlbum(title: String, completionHandler: @escaping (PHAssetCollection?) -> ()) {
//        DispatchQueue.global(qos: .background).async { [weak self] in
//            let fetchOptions = PHFetchOptions()
//            fetchOptions.predicate = NSPredicate(format: "title = %@", title)
//            let collections = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
//
//            if let album = collections.firstObject {
//                completionHandler(album)
//            } else {
//                self?.createAlbum(withTitle: title, completionHandler: { (album) in
//                    completionHandler(album)
//                })
//            }
//        }
//    }
//
//    func createAlbum(withTitle title: String, completionHandler: @escaping (PHAssetCollection?) -> ()) {
//        DispatchQueue.global(qos: .background).async {
//            var placeholder: PHObjectPlaceholder?
//
//            PHPhotoLibrary.shared().performChanges({
//                let createAlbumRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: title)
//                placeholder = createAlbumRequest.placeholderForCreatedAssetCollection
//            }, completionHandler: { (created, error) in
//                var album: PHAssetCollection?
//                if created {
//                    let collectionFetchResult = placeholder.map { PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [$0.localIdentifier], options: nil) }
//                    album = collectionFetchResult?.firstObject
//                }
//
//                completionHandler(album)
//
//            })
//        }
//    }
//
//    private func fetchCustomAlbumPhotos(){
//        let albumName = "asdfadf"
//        var assetCollection = PHAssetCollection()
//        var albumFound = Bool()
//        var photoAssets = PHFetchResult<AnyObject>()
//        let fetchOptions = PHFetchOptions()
//
//        fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
//        let collection: PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
//
//        if let firstObject = collection.firstObject {
//            assetCollection = firstObject
//            albumFound = true
//        } else {
//            albumFound = false
//        }
//        _ = collection.count
//        photoAssets = PHAsset.fetchAssets(in: assetCollection, options: nil) as! PHFetchResult<AnyObject>
//        let imageManager = PHCachingImageManager()
//        photoAssets.enumerateObjects { (object, count, stop) in
//            if object is PHAsset {
//                let asset = object as! PHAsset
//                print("Inside if object is PHAsset, This is number 1")
//
//                let imageSize = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
//
//                let options = PHImageRequestOptions()
//                options.deliveryMode = PHImageRequestOptionsDeliveryMode.fastFormat
//                options.isSynchronous = true
//
//                imageManager.requestImage(for: asset, targetSize: imageSize, contentMode: PHImageContentMode.aspectFill, options: options, resultHandler: { (image, info) in
//                    self.addImgToArray(uploadImage: image!)
//                    print("enum for image, This is number 2")
//                })
//            }
//        }
//    }
    
    
    private func binding(){
    
        // 들어오자마자 바로 ViewModel에 전달
        Observable.just(Void())
            .subscribe(onNext:{
                self.viewModel.didLoad.onCompleted()
            }).disposed(by: disposeBag)
        
        let dataSources = RxCollectionViewSectionedReloadDataSource<PhotoModel>(configureCell: { (dataSource, collectionView, indexPath, item) -> UICollectionViewCell in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifier.albumIdentifier, for: indexPath) as! AlbumCollectionViewCell
            
            self.imageManager.requestImage(for: item, targetSize: CGSize(width: item.pixelWidth, height: item.pixelHeight), contentMode: PHImageContentMode.aspectFill, options: nil) { (image, _) in
                if let image = image {
                    // 각 cell에 imageView에 hero id 추가
                    cell.mainImageView.hero.id = item.originalFilename
                    cell.mainImageView.image = image
                }
            }
            
            return cell
        })
        
        // UICollectionViewDelegateFlowLayout 을 사용하기 때문에
        albumCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        // datasource 추가
        viewModel.posts.asDriver(onErrorJustReturn: [])
            .drive(albumCollectionView.rx.items(dataSource: dataSources))
            .disposed(by: disposeBag)
        
        // collectionViewCell selected
        albumCollectionView.rx.modelSelected(PHAsset.self)
            .subscribe(onNext:{ asd in
                let vc = AlbumDetailViewController()
                vc.asset = asd
                
                // hero animation을 사용하기 위해서는 다음 ViewController에 hero enable을 해줘야된다.
                // navigation이 있다면 navi에 추가해야된다.
                vc.hero.isEnabled = true
                self.present(vc, animated: true, completion: nil)
            }).disposed(by: disposeBag)
        
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
        return CGSize(width: (collectionView.bounds.size.width - 40) * 0.33, height: (collectionView.bounds.size.width - 40) * 0.33)
    }
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Metric.lineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Metric.intetItemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: Metric.edgeInset,left: Metric.edgeInset,bottom: Metric.edgeInset,right: Metric.edgeInset)
    }
}
