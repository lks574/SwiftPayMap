//
//  AlbumDetailViewController.swift
//  SwiftPayMap
//
//  Created by KyungSeok Lee on 2019. 3. 13..
//  Copyright © 2019년 KyungSeok Lee. All rights reserved.
//

import UIKit
import SnapKit
import Then
import Photos
import Hero

class AlbumDetailViewController: UIViewController {

    var asset = PHAsset()
    let imageManager = PHCachingImageManager()
    
    let mainImageView = UIImageView().then{
        $0.contentMode = .scaleAspectFit
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "사진 설명"
        
        uiSetting()
        imageSetting(item: asset)
        
        mainImageView.hero.id = asset.description
    }
    
    private func imageSetting(item: PHAsset){
        self.imageManager.requestImage(for: item, targetSize: CGSize(width: item.pixelWidth, height: item.pixelHeight), contentMode: PHImageContentMode.aspectFill, options: nil) { (image, _) in
            if let image = image {
                self.mainImageView.image = image
            }
        }
    }

    
    private func uiSetting(){
        [mainImageView].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview($0)
        }
        mainImageView.snp.makeConstraints{
            $0.center.equalTo(self.view)
            $0.width.equalTo(self.view).multipliedBy(0.7)
            $0.height.equalTo(self.view).multipliedBy(0.7)
        }
    }
    
}
