//
//  ViewController.swift
//  memorablePlaces
//
//  Created by Kaylan Smith on 7/5/16.
//  Copyright © 2016 Kaylan Smith. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var manager: CLLocationManager!

    @IBOutlet var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        var uilpgr = UILongPressGestureRecognizer(target: self, action: "action:")
        
        uilpgr.minimumPressDuration = 2.0
        
        map.addGestureRecognizer(uilpgr)
        
    }
    
    func action(gestureRecognizer: UILongPressGestureRecognizer) {
    
        // don't want to accidentally capture several long presses (duplicates)
        // runs only once for one long press
        if gestureRecognizer.state == UIGestureRecognizerState.Began {
        
            var touchPoint = gestureRecognizer.locationInView(self.map)
            
            var newCoordinate = map.convertPoint(touchPoint, toCoordinateFromView: self.map)
            
            var location = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
            
            // retrieve address from reverse geocoder
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
                
                var title = ""
                
                if (error == nil) {
                
                    if let p = placemarks?[0] {
                    
                        var subThoroughfare:String = ""
                        var thoroughfare:String = ""
                        
                        if p.subThoroughfare != nil {
                        
                            subThoroughfare = p.subThoroughfare!
                        
                        }
                        
                        if p.thoroughfare != nil {
                            
                            thoroughfare = p.thoroughfare!
                            
                        }
                        
                        title = "\(subThoroughfare) \(thoroughfare)"
                    
                    }
            
                }
            
                if title == "" {
                    
                    title = "Added \(NSDate())"
                
                }
                
                var annotation = MKPointAnnotation()
                
                annotation.coordinate = newCoordinate
                
                annotation.title = title
                
                self.map.addAnnotation(annotation)
                
            })
            
        
        }
        
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [CLLocation]) {
    
        var userLocation:CLLocation = locations[0]
        var latitude = userLocation.coordinate.latitude
        var longitude = userLocation.coordinate.longitude
        var location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        var latDelta:CLLocationDegrees = 0.01
        var lonDelta:CLLocationDegrees = 0.01
        
        var span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        
        var region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        self.map.setRegion(region, animated: true)

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
    


}

