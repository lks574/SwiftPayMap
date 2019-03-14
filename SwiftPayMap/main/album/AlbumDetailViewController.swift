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
    
    let xButton = UIButton().then{
        $0.setTitle("X", for: .normal)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.contentEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
    

    let infoStackView = UIStackView().then{
        $0.axis = .vertical
        $0.spacing = 5.0
    }
    let imageNameLabel = UILabel().then{
        $0.textColor = UIColor.white
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.numberOfLines = 0
    }
    let imageCreationLabel = UILabel().then{
        $0.textColor = UIColor.white
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.numberOfLines = 0
    }
    let imageLocationLabel = UILabel().then{
        $0.textColor = UIColor.white
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.numberOfLines = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        self.navigationItem.title = "사진 설명"
        
        uiSetting()
        imageSetting(item: asset)
        etcSetting()
        infoSetting()
        mainImageView.hero.id = asset.originalFilename
        
    }
    
    private func imageSetting(item: PHAsset){
        self.imageManager.requestImage(for: item, targetSize: CGSize(width: item.pixelWidth, height: item.pixelHeight), contentMode: PHImageContentMode.aspectFill, options: nil) { (image, _) in
            if let image = image {
                self.mainImageView.image = image
            }
        }
    }

    @objc private func xbuttonAction(_ sender : UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    private func infoSetting(){
        if let originalFilename = asset.originalFilename {
            imageNameLabel.text = "originalFilename: \(originalFilename)"
        }
    
        if let creationDate = asset.creationDate {
            let dateFormatter = DateFormatter(withFormat: "yyyyMMdd", locale: "ko_kr")
            imageCreationLabel.text = "creationDate: \(dateFormatter.string(from: creationDate))"
        }
        
        
        if let location = asset.location {
            imageLocationLabel.text = "latitude: \(location.coordinate.latitude), longitude: \(location.coordinate.longitude)"
        }
        
    }
    
    private func etcSetting(){
        xButton.addTarget(self, action: #selector(xbuttonAction(_:)), for: .touchUpInside)
    }
    
    private func uiSetting(){
        [mainImageView, xButton, infoStackView].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview($0)
        }
        mainImageView.snp.makeConstraints{
            $0.center.equalTo(self.view)
            $0.width.equalTo(self.view).multipliedBy(0.8)
            $0.height.equalTo(self.view).multipliedBy(0.8)
        }
        xButton.snp.makeConstraints{
            $0.top.equalTo(self.view.safeArea.top).offset(15)
            $0.trailing.equalTo(self.view.snp.trailing).offset(-10)
        }
        infoStackView.snp.makeConstraints{
            $0.bottom.equalTo(self.view.safeArea.bottom).offset(-10)
            $0.leading.equalTo(mainImageView)
            $0.trailing.equalTo(mainImageView)
        }
        
        [imageNameLabel, imageCreationLabel, imageLocationLabel].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            infoStackView.addArrangedSubview($0)
        }
    }
    
}



