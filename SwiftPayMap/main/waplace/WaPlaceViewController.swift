//
//  WaPlaceViewController.swift
//  SwiftPayMap
//
//  Created by KyungSeok Lee on 2019. 3. 14..
//  Copyright © 2019년 KyungSeok Lee. All rights reserved.
//

import UIKit

class WaPlaceViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        self.navigationItem.title = "와플"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "hamburger-black"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(hamburgerAction(_:)))
        uiSetting()
    }
    
    @objc private func hamburgerAction(_ sender: UIBarButtonItem){
        let vc = WaPlaceSearchViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func uiSetting(){
        
    }

}
