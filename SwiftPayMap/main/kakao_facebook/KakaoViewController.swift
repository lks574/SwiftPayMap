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
import FBSDKCoreKit
import FBSDKLoginKit


// 카카오 페이스북
class KakaoViewController: BaseViewController {
    
    private let kakaoLoginButton = KOLoginButton()
    private let facebookLoginButton = FBSDKLoginButton()
    
    private let nicknameLabel = UILabel().then{
        $0.textColor = UIColor.black
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.numberOfLines = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiSetting()
        etcSetting()
        
        
        if (FBSDKAccessToken.current() == nil) {
            
        }else{
            
        }
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
//        facebookLoginButton.addTarget(self, action: #selector(facebookLoginButton(_:)), for: .touchUpInside)
        
        // 페이스북 로그인 권한 추가
        facebookLoginButton.readPermissions = ["public_profile", "email"]
        facebookLoginButton.delegate = self
    }
    
    private func uiSetting(){
        [kakaoLoginButton, facebookLoginButton, nicknameLabel].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview($0)
        }
        
        kakaoLoginButton.snp.makeConstraints{
            $0.top.equalTo(self.safeTop())
            $0.centerX.equalTo(self.view.snp.centerX)
            $0.height.equalTo(60)
            $0.width.equalTo(self.view.snp.width).multipliedBy(0.8)
        }
        
        facebookLoginButton.snp.makeConstraints{
            $0.top.equalTo(kakaoLoginButton.snp.bottom).offset(10)
            $0.centerX.equalTo(kakaoLoginButton.snp.centerX)
            $0.height.equalTo(kakaoLoginButton.snp.height)
            $0.width.equalTo(kakaoLoginButton.snp.width)
        }
        
        nicknameLabel.snp.makeConstraints{
            $0.top.equalTo(facebookLoginButton.snp.bottom).offset(10)
            $0.centerX.equalTo(kakaoLoginButton.snp.centerX)
        }
    }


}


extension KakaoViewController : FBSDKLoginButtonDelegate {
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult?, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        }else if let result = result{
            if result.isCancelled {
                
            }else {
                FBSDKProfile.loadCurrentProfile { (profile, error) in
                    if let profile = profile {
                        self.nicknameLabel.text = "firstName: \(String(profile.firstName)), id: \(String(profile.userID))"
                    }
                }
            }
        }
        
//        if result.isCancelled{
//
//        }else if result.isAccessibilityElement {
//            FBSDKProfile.loadCurrentProfile { (profile, error) in
//                if let profile = profile {
//
//                    let alert = UIAlertController(title: "페이스북 로그인", message: String(profile.firstName), preferredStyle: .alert)
//
//                    alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: { (action) in
//
//                    }))
//                    self.present(alert, animated: true, completion: nil)
//                }
//            }
//        }else{
//
//        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        let alert = UIAlertController(title: "페이스북 로그아웃", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: { (action) in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
