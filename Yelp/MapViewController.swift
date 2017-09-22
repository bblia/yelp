//
//  MapViewController.swift
//  Yelp
//
//  Created by Lia Zadoyan on 9/21/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
     var locationManager : CLLocationManager!
    var businesses: [Business]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self

        // set the region to display, this also sets a correct zoom level
        // set starting center location in San Francisco
        let centerLocation = CLLocation(latitude: 37.7833, longitude: -122.4167)
        goToLocation(location: centerLocation)
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 100
        locationManager.requestWhenInUseAuthorization()
        
        for business in businesses {
            addAnnotationAtAddress(address: business.displayAddress!, business: business)
        }
    }
    
    func goToLocation(location: CLLocation) {
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        mapView.setRegion(region, animated: false)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpanMake(0.1, 0.1)
            let region = MKCoordinateRegionMake(location.coordinate, span)
            mapView.setRegion(region, animated: false)
        }
    }
    
    @IBAction func onListSelected(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func addAnnotationAtAddress(address: String, business: Business) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            if let placemarks = placemarks {
                if placemarks.count != 0 {
                    let coordinate = placemarks.first!.location!
                    let annotation = Annotation(coordinate: coordinate.coordinate)
                    annotation.business = business
                    self.mapView.addAnnotation(annotation)
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var view = mapView.dequeueReusableAnnotationView(withIdentifier: "MapAnnotationView")
        view = MapAnnotationView(annotation: annotation, reuseIdentifier: "MapAnnotationView")
        view?.canShowCallout = false
        
        return view
    
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view is MapAnnotationView {
            let views = Bundle.main.loadNibNamed("AnnotationView", owner: nil, options: nil)
            let annotationView = views?[0] as! AnnotationView
            annotationView.center = CGPoint(x: view.bounds.size.width, y: -annotationView.bounds.size.height)
            
            let annotation = view.annotation as! Annotation
            annotationView.business = annotation.business

            view.addSubview(annotationView)
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        for view in view.subviews {
            view.removeFromSuperview()
        }
        
    }

}
