//
//  BaseViewController.swift
//  SwiftPayMap
//
//  Created by KyungSeok Lee on 2019. 3. 4..
//  Copyright © 2019년 KyungSeok Lee. All rights reserved.
//

import UIKit
import SnapKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
    }
    
    
    func safeTop() -> ConstraintItem {
        if #available(iOS 11.0, *) {
            return self.view.safeAreaLayoutGuide.snp.top
        } else {
            return self.topLayoutGuide.snp.top
        }
    }
    
    func safeBottom() -> ConstraintItem {
        if #available(iOS 11.0, *) {
            return self.view.safeAreaLayoutGuide.snp.bottom
        } else {
            return self.topLayoutGuide.snp.bottom
        }
    }
    
    


}


