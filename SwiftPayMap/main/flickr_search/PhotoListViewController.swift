//
//  PhotoListViewController.swift
//  SwiftPayMap
//
//  Created by KyungSeok Lee on 2019. 3. 6..
//  Copyright © 2019년 KyungSeok Lee. All rights reserved.
//

import UIKit

import Kingfisher
import ReactorKit
import ReusableKit
import RxCocoa
import RxDataSources
import RxOptional
import RxSwift
import SnapKit
import Then


class PhotoListViewController: UIViewController {

    // CollectionView 재사용
    struct Reusable {
        static let flickrCell = ReusableCell<PhotoCell>()
    }
    
    struct Constant {
        static let cellIdentifier = "cell"
    }
    struct Metric {
        static let lineSpacing: CGFloat = 10
        static let intetItemSpacing: CGFloat = 10
        static let edgeInset: CGFloat = 8
    }
    
    var disposeBag: DisposeBag = DisposeBag()
    
    // 상단 서치바
    let searchBar = UISearchBar(frame: .zero).then {
        $0.searchBarStyle = .prominent
        $0.placeholder = "Search Flickr"
        $0.sizeToFit()
    }
    
    // 이미지 CollectionView
    let collectionView = UICollectionView(frame: .zero,collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.backgroundColor = .white
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(Reusable.flickrCell)
    }
    
    // 이미지 CollectionView dataSources
    let dataSources = RxCollectionViewSectionedReloadDataSource<Photos>(configureCell: { (dataSource, collectionView, indexPath, item) -> UICollectionViewCell in
        let cell = collectionView.dequeue(Reusable.flickrCell, for: indexPath)
        if let imageURL = item.flickrURL(), let url = URL(string: imageURL){
            cell.flickrPhoto.kf.setImage(with: url)
        }
        return cell
    })
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Search RxFlickr"
        self.view.addSubview(searchBar)
        self.view.addSubview(collectionView)
        
        setupConstraints()
    }
    
    init(reactor: PhotoListViewReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints(){
        self.searchBar.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeArea.top)
            make.left.right.equalTo(self.view)
        }
        
        self.collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.searchBar.snp.bottom)
            make.left.right.bottom.equalTo(self.view)
        }
    }
}


extension PhotoListViewController : ReactorKit.View {
    
    func bind(reactor: PhotoListViewReactor) {
        // DataSource
        self.collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        self.collectionView.rx.modelSelected(Photo.self).subscribe(onNext: { photo in
            let view = DetailViewController()
            view.photo = photo
            self.navigationController?.pushViewController(view, animated: true)
        })
            .disposed(by: disposeBag)
        
        // Action
        self.searchBar.rx.text
            .orEmpty
            .debounce(1.0, scheduler: MainScheduler.instance)
            .filter { !$0.isEmpty }
            .map(Reactor.Action.searchFlickr)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // State
        reactor.state.asObservable().map { $0.photos }
            .replaceNilWith([])
            .bind(to: collectionView.rx.items(dataSource: dataSources))
            .disposed(by: disposeBag)
    }
}


extension PhotoListViewController: UICollectionViewDelegateFlowLayout {
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
