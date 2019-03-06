//
//  PGViewController.swift
//  SwiftPayMap
//
//  Created by KyungSeok Lee on 2019. 3. 4..
//  Copyright © 2019년 KyungSeok Lee. All rights reserved.
//

import UIKit
import SnapKit
import WebKit

class PGViewController: UIViewController {

    private let wkWebView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "PG"
        uiSetting()
        etcSetting()
        
        let url = URL(string: "https://www.google.co.kr")
        let request = URLRequest(url: url!)
        wkWebView.load(request)
    }
    
    private func etcSetting(){
        wkWebView.navigationDelegate = self
        wkWebView.uiDelegate = self
    }
    
    private func uiSetting(){
        [wkWebView].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview($0)
        }
        
        wkWebView.snp.makeConstraints{
            $0.top.equalTo(self.view.safeArea.top)
            $0.bottom.equalTo(self.view.safeArea.bottom)
            $0.leading.equalTo(self.view.snp.leading)
            $0.trailing.equalTo(self.view.snp.trailing)
        }
    }
    
}

extension PGViewController: WKNavigationDelegate, WKUIDelegate {
    
    // TODO: 정확히 뭔지 찾아보기
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    
        // 쿠키 강제 허용
        HTTPCookieStorage.shared.cookieAcceptPolicy = HTTPCookie.AcceptPolicy.always
        
        // 이니시스를 통해 전달되는 URL
        guard let url = navigationAction.request.url else { return }
        let urlString = url.absoluteString
        
        // URL을 읽어왔을 떄 애플 스토어 주소인 경우 사파리에 해당 URL을 넘겨서 앱스토어에서 설치 할 수 있도록 유도
        let isStoreUrl = urlString.contains("phobos.apple.com")
        let isStoreUrl2 = urlString.contains("itunes.apple.com")
        
        
        if isStoreUrl||isStoreUrl2 {
            // 앱스토어 이동
            UIApplication.shared.open(url)
            decisionHandler(.cancel)
        }else if urlString.hasPrefix("http") || urlString.hasPrefix("https") || urlString.hasPrefix("about") {
            // 일반적인 웹 url 형태인 경우 진행
            decisionHandler(.allow)
        }else{
            // 그외의 값은 앱스키마로 간주하여 앱 호출
            guard let appUrl = URL(string: urlString) else {return}
            if !UIApplication.shared.canOpenURL(appUrl){
                decisionHandler(.cancel)
            }
        }
//        decisionHandler(.allow)
    }
}
