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
    
    let searchController = UISearchController(searchResultsController: nil)
    
    let locationManager = CLLocationManager()
    let meter: Double = 50000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationService()
        setupSearch()
    }
    
    func setup() {
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    func setupSearch(){
        
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = "Search places"
        navigationItem.searchController = searchController
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
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
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            break
        }
        
    }
    func searchMap() {
        
        guard let searchBarText = searchController.searchBar.text else { return }
        let request = MKLocalSearch.Request()
        print(searchBarText)
        request.naturalLanguageQuery = searchBarText
        if let locat = locationManager.location?.coordinate{
            request.region = MKCoordinateRegion(center: locat, latitudinalMeters: meter, longitudinalMeters: meter) }
        
        let search = MKLocalSearch(request: request)
        search.start(completionHandler: {(response, error) in
            
            for item in response!.mapItems {
                self.addPinToMapView(title: item.name, latitude: item.placemark.location!.coordinate.latitude, longitude: item.placemark.location!.coordinate.longitude)
            }
        })
    }
    
    func addPinToMapView(title: String?, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        if let title = title {
            let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let annotation = MKPointAnnotation()
            
            annotation.coordinate = location
            annotation.title = title
            
            userView.addAnnotation(annotation)
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

extension MapViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        userView.removeAnnotations(userView.annotations)
        searchMap()
    }
    
    
}
