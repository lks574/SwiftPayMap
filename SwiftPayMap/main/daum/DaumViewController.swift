//
//  DaumViewController.swift
//  SwiftPayMap
//
//  Created by KyungSeok Lee on 2019. 3. 4..
//  Copyright © 2019년 KyungSeok Lee. All rights reserved.
//


// https://yangfra.tistory.com/25 참고
import UIKit
import SnapKit
import CoreLocation

class DaumViewController: BaseViewController {

    private let mapView: MTMapView = MTMapView(frame: .zero)
    
    
//    private var locationManager: CLLocationManager!
//    private var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "다음 지도"
        
//        locationManager = CLLocationManager()
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//
//        if CLLocationManager.locationServicesEnabled() {
//            locationManager.requestWhenInUseAuthorization()
//            locationManager.startUpdatingLocation()
//        }
        
        uiSetting()
        etcSetting()
    
    }
    
    private func mapMaker(geo: MTMapPointGeo, tag: Int){
        let currentPostionItem = MTMapPOIItem()
        currentPostionItem.itemName = "Current Postion"
        currentPostionItem.mapPoint = MTMapPoint(geoCoord: geo)
        currentPostionItem.markerType = MTMapPOIItemMarkerType.bluePin
        currentPostionItem.showAnimationType = .noAnimation
        currentPostionItem.draggable = true
        currentPostionItem.tag = tag
        
        mapView.addPOIItems([currentPostionItem])
        mapView.fitAreaToShowAllPOIItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        mapView.currentLocationTrackingMode = .onWithoutHeading
        
        var items = [MTMapPOIItem]()
        items.append(poiItem(name: "하나", latitude: 37.4981688, longitude: 127.0484572))
        items.append(poiItem(name: "둘", latitude: 37.4987963, longitude: 127.0415946))
        items.append(poiItem(name: "셋", latitude: 37.5025612, longitude: 127.0415946))
        items.append(poiItem(name: "넷", latitude: 37.5037539, longitude: 127.0426469))
        //위 부분은 viewDidLoad()에서 수행해도 괜찮습니다
        
        mapView.addPOIItems(items)
        mapView.fitAreaToShowAllPOIItems()  // 모든 마커가 보이게 카메라 위치/줌 조정
    }
    
    func poiItem(name: String, latitude: Double, longitude: Double) -> MTMapPOIItem {
        let item = MTMapPOIItem()
        item.itemName = name
        item.markerType = .redPin
        item.markerSelectedType = .redPin
        item.mapPoint = MTMapPoint(geoCoord: .init(latitude: latitude, longitude: longitude))
        item.showAnimationType = .noAnimation
        item.customImageAnchorPointOffset = .init(offsetX: 30, offsetY: 0)    // 마커 위치 조정
        
        return item
    }
    
    
    private func etcSetting(){
        mapView.delegate = self
        mapView.baseMapType = .standard
        
    }
    
    private func uiSetting(){
        [mapView].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview($0)
        }
        mapView.snp.makeConstraints{
            $0.top.equalTo(self.safeTop())
            $0.bottom.equalTo(self.safeBottom())
            $0.leading.equalTo(self.view.snp.leading)
            $0.trailing.equalTo(self.view.snp.trailing)
        }
    }
    

}

extension DaumViewController: MTMapViewDelegate {
    func mapView(_ mapView: MTMapView!, updateCurrentLocation location: MTMapPoint!, withAccuracy accuracy: MTMapLocationAccuracy) {
        let currentLocationPointGeo = location.mapPointGeo()
//        mapMaker(geo: currentLocationPointGeo, tag: 10)
        print("MTMapView updateCurrentLocation \(currentLocationPointGeo.latitude), \(currentLocationPointGeo.longitude), accuracy \(accuracy)")
        
    }
    
    func mapView(_ mapView: MTMapView!, updateDeviceHeading headingAngle: MTMapRotationAngle) {
        print("MTMapView updateDeviceHeading \(headingAngle) degress")
    }
    
}

