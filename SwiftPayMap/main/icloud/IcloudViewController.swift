//
//  IcloudViewController.swift
//  SwiftPayMap
//
//  Created by KyungSeok Lee on 2019. 3. 18..
//  Copyright © 2019년 KyungSeok Lee. All rights reserved.
//

import UIKit
import CoreLocation
import CloudKit
class IcloudViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "아이클라이드 동기화"
        uiSetting()
    }

}

extension IcloudViewController {
    
    private func uiSetting(){
        
    }
}
