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
        
        let marker = MTMapPOIItem()
        marker.itemName = "Sample"
        marker.tag = 10
        marker.mapPoint = MTMapPoint(geoCoord: .init(latitude: 37.4981688, longitude: 127.0484572))
        marker.markerType = .bluePin
        marker.showAnimationType = .noAnimation
        
        let marker2 = MTMapPOIItem()
        marker2.itemName = "Sample2"
        marker2.tag = 10
        marker2.mapPoint = MTMapPoint(geoCoord: .init(latitude: 37.5, longitude: 127.1))
        marker2.markerType = .redPin
        marker2.showAnimationType = .noAnimation
        
        mapView.addPOIItems([marker, marker2])
        mapView.fitAreaToShowAllPOIItems()
//        sampleMarker()
        
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

