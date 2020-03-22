//
//  MapViewController.swift
//  PriceWatch
//
//  Created by Min on 3/19/20.
//  Copyright © 2020 Min. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import MapKitSearchView

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var nextPage: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    let updateLocationDistance = 1609.34*2
    
    var geoPostLocations = [CLLocation]()
    var key: String?
    
    var locationManager = CLLocationManager()
    var mapHelper = PWMapHelper()
    var currentAnnotation: MKPointAnnotation? = nil
    var tapGestureRecognizer: UITapGestureRecognizer?
    var previousLocation: CLLocation? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextPage.alpha = 0
        cancelButton.alpha = 0
        map.showsUserLocation = true
        locationManager.delegate = self
        map.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func resetMap() {
        if let currentAnnotation = currentAnnotation {
            map.removeAnnotation(currentAnnotation)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is MKUserLocation) {
            let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: String(annotation.hash))
            let rightButton = UIButton(type: .contactAdd)
            let mapTapGestureRecognizer = MapTapGestureRecognizer(target: self, action: #selector(MapViewController.seeDetails(gestureRecognizer:)))
            if let annotation = annotation as? PointAnnotation {
                mapTapGestureRecognizer.key = annotation.key
            }
            rightButton.addGestureRecognizer(mapTapGestureRecognizer)
            rightButton.tag = annotation.hash
            pinView.canShowCallout = true
            pinView.rightCalloutAccessoryView = rightButton
            pinView.animatesDrop = false
            return pinView
        }
        else {
            return nil
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "addPostDetails") {
            if let nextVC = segue.destination as? CreatePostViewController {
                nextVC.annotation = currentAnnotation
                resetMap()
                currentAnnotation = nil
            }
        }
        if (segue.identifier == "seeDetails") {
            if let nextVC = segue.destination as? PostDetailsViewController {
                nextVC.postKey = key
            }
        }
    }
    
    @objc func seeDetails(gestureRecognizer: MapTapGestureRecognizer) {
        self.key = gestureRecognizer.key
        performSegue(withIdentifier: "seeDetails", sender: self)
    }
    
    @objc func addAnnotation(gestureRecognizer: UIGestureRecognizer) {
        let touchPoint = gestureRecognizer.location(in: self.map)
        let coordinate = map.convert(touchPoint, toCoordinateFrom: self.map)
        if let annotation = currentAnnotation {
            annotation.coordinate = coordinate
        } else {
            let annotation = PointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = ""
            annotation.subtitle = ""
            currentAnnotation = annotation
            map.addAnnotation(annotation)
        }
    }
    
    @IBAction func createPost(_ sender: Any) {
        nextPage.alpha = 1
        cancelButton.alpha = 1
        if (UserService.userOnBoarding()) {
            let alertController = UIAlertController(title: "Select a new location", message: "Tap on a location", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            present(alertController, animated: true)
        }
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MapViewController.addAnnotation(gestureRecognizer:)))
        map.addGestureRecognizer(tapGestureRecognizer!)
    }
    
    @IBAction func addPostDetails(_ sender: Any) {
        //set currentAnnotation to nil once post is made
        map.removeGestureRecognizer(tapGestureRecognizer!)
        if let annotation = currentAnnotation {
            performSegue(withIdentifier: "addPostDetails", sender: self)
        }
        nextPage.alpha = 0
        cancelButton.alpha = 0
    }
    
    @IBAction func cancelPost(_ sender: Any) {
        nextPage.alpha = 0
        cancelButton.alpha = 0
        map.removeGestureRecognizer(tapGestureRecognizer!)
        if let annotation = currentAnnotation {
            map.removeAnnotation(annotation)
            currentAnnotation = nil
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations[0]
        if (previousLocation == nil || previousLocation!.distance(from: userLocation) > updateLocationDistance) {
            previousLocation = userLocation
            let latitude = userLocation.coordinate.latitude
            let longitude = userLocation.coordinate.longitude
            let region: MKCoordinateRegion = mapHelper.setRegion(latitude: latitude, longitude: longitude)
            map.setRegion(region, animated: true)
        }
        
        let searchLocation = CLLocation(latitude: map!.centerCoordinate.latitude, longitude: map!.centerCoordinate.longitude)
        UserService.geoPosts(for: searchLocation) { (keys, locations) in
            self.geoPostLocations = locations
            for i in 0..<self.geoPostLocations.count {
                let location = self.geoPostLocations[i]
                let annotation = PointAnnotation()
                annotation.title = "See details"
                annotation.key = keys[i]
                annotation.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude as! Double, longitude: location.coordinate.longitude as! Double)
                self.map.addAnnotation(annotation)
            }
        }
        
    }
    
    override func unwind(for unwindSegue: UIStoryboardSegue, towards subsequentVC: UIViewController) {
        
    }
    
    @IBAction func cancel(_ unwindSegue: UIStoryboardSegue) {}

}
