//
//  ViewController.swift
//  LocationTracker
//
//  Created by Ryan Newton on 12/11/15.
//  Copyright (c) 2015 ___rvkn___. All rights reserved.
//

import UIKit
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        self.setupLocationManager()
        
    }
    @IBAction func displayCoordinates(sender: UIButton) {
        println("Your Location")
        println(getCurrentLocationAsString())
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 30
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if UIApplication.sharedApplication().applicationState == UIApplicationState.Active {
            //            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            println(getCurrentLocationAsString())
        }
            
        else if UIApplication.sharedApplication().applicationState == UIApplicationState.Background {
            //            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            NSLog("App is backgrounded. New location is %@", getCurrentLocationAsString())
        }
        
        
        sendLocationData()
        
    }
    
    func getCurrentLocationAsString() -> String {
        if let location = locationManager.location {
            return "\(location.coordinate.latitude),\(location.coordinate.longitude)"
        } else {
            return "No real location manager"
            
        }
    }
    
    func sendLocationData() {
        //        var locationCoordinates = PFObject(className:"LocationCoordinates")
        //        locationCoordinates["location"] = getCurrentLocationAsString()
        //
        //        locationCoordinates.saveInBackgroundWithBlock {
        //            (success: Bool, error: NSError?) -> Void in
        //            if (success) {
        //                println("saved")
        //            } else {
        //                println("error")
        //            }
        //        
        //        }
        
    }
    
}

