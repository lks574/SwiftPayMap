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

    private let mapView: MTMapView = MTMapView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "다음 지도"
        
        
        uiSetting()
        etcSetting()
        
        let marker = MTMapPOIItem()
        marker.itemName = "sample"
        marker.markerType = .customImage
        marker.customImageName = "custom_poi_marker.png"
        marker.mapPoint = MTMapPoint(geoCoord: .init(latitude: 37.4981688, longitude: 127.0484572))
        marker.showAnimationType = .noAnimation
        
        let marker2 = MTMapPOIItem()
        marker2.itemName = "sample2"
        marker2.markerType = .customImage
        marker2.customImageName = "custom_poi_marker.png"
        marker2.mapPoint = MTMapPoint(geoCoord: .init(latitude: 37.5, longitude: 127.1))
        marker2.showAnimationType = .noAnimation
        
        let marker3 = MTMapPOIItem()
        marker3.itemName = "다음"
        marker3.markerType = .customImage
        marker3.customImageName = "custom_poi_marker.png"
        marker3.mapPoint = MTMapPoint(geoCoord: .init(latitude: 37.55, longitude: 127.15))
        marker3.showAnimationType = .springFromGround
        
        mapView.addPOIItems([marker, marker2, marker3])
        mapView.fitAreaToShowAllPOIItems()
        
//        mapView.currentLocationTrackingMode = .onWithoutHeading
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
    
    
    func mapView(_ mapView: MTMapView!, selectedPOIItem poiItem: MTMapPOIItem!) -> Bool {
        return true
    }
    
    func mapView(_ mapView: MTMapView!, doubleTapOn mapPoint: MTMapPoint!) {
        
    }
    
}

