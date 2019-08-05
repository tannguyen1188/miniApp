//
//  ViewController.swift
//  MapKitMiniApp
//
//  Created by Consultant on 8/3/19.
//  Copyright © 2019 Mobile Apps Company. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var userView: MKMapView!
    
    let locationManager = CLLocationManager()
    let meter: Double = 5000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationService()
    }
    
    func setup() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func centerView() {
        if let locat = locationManager.location?.coordinate{
            let region = MKCoordinateRegion.init(center: locat, latitudinalMeters: meter, longitudinalMeters: meter)
            userView.setRegion(region, animated: true)
        }
    }
    func checkLocationService () {
        if CLLocationManager.locationServicesEnabled(){
            setup()
            checkAuthorization()
        } else {
            
        }
            
        }
    func checkAuthorization(){
        
        switch CLLocationManager.authorizationStatus(){
            
        case .authorizedWhenInUse:
            userView.showsUserLocation = true
            centerView()
            locationManager.startUpdatingLocation()
        case .denied:
            break
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
            
        case .authorizedAlways:
            break
            
        @unknown default:
            break
        }
        
    }
        
    }



extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locat = locations.last else { return }
        let center = CLLocationCoordinate2D(latitude: locat.coordinate.latitude, longitude: locat.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: meter, longitudinalMeters: meter)
        userView.setRegion(region, animated: true)
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkAuthorization()
    }
    
}
