//
//  HomeViewController.swift
//  SwiftPayMap
//
//  Created by KyungSeok Lee on 2019. 3. 4..
//  Copyright © 2019년 KyungSeok Lee. All rights reserved.
//

import UIKit
import Then
import SnapKit

class HomeViewController: BaseViewController {

    private let mainTableView = UITableView(frame: .zero).then{
        $0.tableFooterView = UIView(frame: .zero)
    }
    
    private let tableArray = ["iap","pg","daum map", "카카오 로그인", "RX"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "샘플"
        uiSetting()
        etcSetting()
        
    }
    
    private func etcSetting(){
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
        mainTableView.register(UITableViewCell.self, forCellReuseIdentifier: "mainCell")
    }
    
    private func uiSetting(){
        [mainTableView].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview($0)
        }
        
        mainTableView.snp.makeConstraints{
            $0.top.equalTo(self.safeTop())
            $0.bottom.equalTo(self.safeBottom())
            $0.leading.equalTo(self.view.snp.leading)
            $0.trailing.equalTo(self.view.snp.trailing)
        }
    }

}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath)
        cell.textLabel?.text = tableArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            break
        case 1:
            let vc = PGViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 2:
            let vc = DaumViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 3:
            let vc = KakaoViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case 4:
            let vc = RxSwiftViewController()
            self.navigationController?.pushViewController(vc, animated: true)
    
        default:
            break
        }
    }
}
