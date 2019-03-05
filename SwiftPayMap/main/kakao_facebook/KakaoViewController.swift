//
//  KakaoViewController.swift
//  SwiftPayMap
//
//  Created by KyungSeok Lee on 2019. 3. 5..
//  Copyright © 2019년 KyungSeok Lee. All rights reserved.
//

import UIKit
import Then
import KakaoOpenSDK

class KakaoViewController: BaseViewController {
    
    private let kakaoLoginButton = KOLoginButton()
    private let nicknameLabel = UILabel().then{
        $0.textColor = UIColor.black
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.numberOfLines = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiSetting()
        etcSetting()
    }
    
    @objc private func kakaoLoginAction(_ sender: KOLoginButton){
        guard let session = KOSession.shared() else { return }
      
        if session.isOpen() {
            session.close()
        }
        session.presentingViewController = self
        session.open { (error) in
            if error != nil {
                print("session.open" + error!.localizedDescription)
            }else if session.isOpen() {
                KOSessionTask.userMeTask(completion: { (error, koUserMe) in
                    if let userMe = koUserMe {
                        if let nickname = userMe.nickname, let id = userMe.id{
                            self.nicknameLabel.text = "nickname: \(nickname), id: \(id)"
                        }
                        
                        if let profileImage = userMe.profileImageURL {
                            print(profileImage.absoluteString)
                        }
                        
                        if let thumbnail = userMe.thumbnailImageURL{
                            print(thumbnail.absoluteString)
                        }
                    }else{
                        if let error = error {
                            print("KOSessionTask.userMeTask" + error.localizedDescription)
                        }
                    }
                })
            }else{
                print("isNotOpen")
            }
        }
    }
    
    private func etcSetting(){
        kakaoLoginButton.addTarget(self, action: #selector(kakaoLoginAction(_:)), for: .touchUpInside)
    }
    
    private func uiSetting(){
        [kakaoLoginButton,nicknameLabel].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview($0)
        }
        
        kakaoLoginButton.snp.makeConstraints{
            $0.top.equalTo(self.safeTop())
            $0.centerX.equalTo(self.view.snp.centerX)
            $0.height.equalTo(42)
            $0.width.equalTo(self.view.snp.width).multipliedBy(0.8)
        }
        
        nicknameLabel.snp.makeConstraints{
            $0.top.equalTo(kakaoLoginButton.snp.bottom).offset(10)
            $0.centerX.equalTo(kakaoLoginButton.snp.centerX)
        }
    }


}
