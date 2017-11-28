//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by Павел Собянин on 15.02.17.
//  Copyright © 2017 pavel.sobyanin. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var mapView: MKMapView!
    var zoomButton: UIButton!
    var locationManager: CLLocationManager!
    
    @objc func userLocation(_ sender: UIButton) {
        //print ("Pressed button")
        
        let userLocation = mapView.userLocation
        if let loc = userLocation.location {
            //print(1)
            let region = MKCoordinateRegionMakeWithDistance((loc.coordinate), 2000, 2000)
            mapView.setRegion(region, animated: true)
        }
        else {
            print ("no location defined...")
        }
    }
    
    @objc func mapTypeChanged (_ segControl: UISegmentedControl) {
        switch segControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .satellite
        case 2:
            mapView.mapType = .hybrid
        default:
            break
        }
    }
    
    override func loadView() {
        mapView = MKMapView()
        
        view = mapView
        
        //let segmentControl = UISegmentedControl(items: ["Standard", "Satellite", "Hybrid"])
        
        let standardString = NSLocalizedString("Standard", comment: "Standard map view")
        let satelliteString = NSLocalizedString("Satellite", comment: "Satellite map view")
        let satelliteHybrid = NSLocalizedString("Hybrid", comment: "Hybrid map view")
        
        let segmentControl = UISegmentedControl(items: [standardString, satelliteString, satelliteHybrid])
        
        segmentControl.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        segmentControl.selectedSegmentIndex = 0
        
        segmentControl.addTarget(self, action: #selector(MapViewController.mapTypeChanged(_:)), for: .valueChanged)
        
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(segmentControl)
        
        let topConstraint = segmentControl.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 8)
        // let leadingConstraint = segmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        // let trailingConstraint = segmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        
        let margins = view.layoutMarginsGuide
        
        let leadingConstraint = segmentControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let trailingConstraint = segmentControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        
        topConstraint.isActive = true
        leadingConstraint.isActive = true
        trailingConstraint.isActive = true
        
        let zoomButton = UIButton()
        zoomButton.backgroundColor = UIColor.green
        zoomButton.setTitle(NSLocalizedString("I'm here", comment: "My Location Button"), for: .normal)
        zoomButton.addTarget(self, action: #selector(MapViewController.userLocation(_:)), for: .touchUpInside)
        zoomButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(zoomButton)
        
        //zoomButton.centerY = view.centerY
        
        //zoomButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        zoomButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        //let topConstraintZoomButton = zoomButton.centerYAnchor
        let trailingConstraintZoomButton = zoomButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 0)
        
        //topConstraintZoomButton.isActive = true
        trailingConstraintZoomButton.isActive = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print ("Map Controller loaded its view")
        mapView.showsUserLocation = true
        
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        
        // mapView.showsUserLocation = true
    }
}
