//
//  AppleMapViewController.swift
//  SwiftPayMap
//
//  Created by KyungSeok Lee on 2019. 3. 6..
//  Copyright © 2019년 KyungSeok Lee. All rights reserved.
//

import UIKit
import MapKit

class AppleMapViewController: UIViewController {

    let locationManager = CLLocationManager()
    let regionInMeters: Double = 10000
    var previousLocation: CLLocation?
    
    private let mapView = MKMapView(frame: .zero)
    private let addressLabel = UILabel(frame: .zero).then{
        $0.textColor = UIColor.black
        $0.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        $0.textAlignment = NSTextAlignment.center
    }
    private let centerView = UIView(frame: .zero).then{
        $0.backgroundColor = UIColor.red
        $0.layer.cornerRadius = 10
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationAutohorization()
        self.navigationItem.title = "애플 지도"
        [mapView, addressLabel,centerView].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview($0)
        }
        
        mapView.snp.makeConstraints{
            $0.top.equalTo(self.view.safeArea.top)
            $0.leading.equalTo(self.view)
            $0.trailing.equalTo(self.view)
        }
        addressLabel.snp.makeConstraints{
            $0.top.equalTo(mapView.snp.bottom)
            $0.height.equalTo(80)
            $0.leading.equalTo(mapView)
            $0.trailing.equalTo(mapView)
            $0.bottom.equalTo(self.view.safeArea.bottom)
        }
        centerView.snp.makeConstraints{
            $0.height.width.equalTo(20)
            $0.center.equalTo(mapView)
        }
        mapView.delegate = self
        maker()
    }
    
    private func maker(){
        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics.")
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand years ago.")
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light.")
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.")
        let washington = Capital(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.")
        
        mapView.addAnnotation(london)
        mapView.addAnnotation(oslo)
        mapView.addAnnotation(paris)
        mapView.addAnnotation(rome)
        mapView.addAnnotation(washington)
    }
    
    
    private func setupLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    private func centerViewOnUserLocation(){
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    private func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAutohorization()
        }else{
            
        }
    }
    
    private func checkLocationAutohorization(){
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
           startTackingUserLocoation()
            break
        case .denied:
            // permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            // show an alert letting them know what's up
            break
        case .authorizedAlways:
            break
        }
    }
    
    private func startTackingUserLocoation(){
        mapView.showsUserLocation = true
        centerViewOnUserLocation()
        locationManager.startUpdatingLocation()
        previousLocation = getCenterLocation(for: mapView)
    }
    
    private func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        return CLLocation(latitude: latitude, longitude: longitude)
    }

}

extension AppleMapViewController: MKMapViewDelegate, CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.last else {return}
//        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//        let region = MKCoordinateRegion(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
//        mapView.setRegion(region, animated: true)
//    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAutohorization()
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getCenterLocation(for: mapView)
        let geoCoder = CLGeocoder()
        guard let previousLocation = self.previousLocation else {return}
        guard center.distance(from: previousLocation) > 50 else { return }
        self.previousLocation = center
        
        geoCoder.reverseGeocodeLocation(center) { [weak self] (placemarks, error) in
            guard let self = self else {return}
            
            if let _ = error {
                return
            }
            guard let placemark = placemarks?.first else {
                return
            }
            let streatNumber = placemark.subThoroughfare ?? ""
            let streatName = placemark.thoroughfare ?? ""
            
            DispatchQueue.main.async {
                self.addressLabel.text = "\(streatNumber) \(streatName)"
            }
        }
        
        
    }
}

class Capital: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    
    init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }
}
