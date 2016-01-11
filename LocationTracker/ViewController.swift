//
//  ViewController.swift
//  LocationTracker
//
//  Created by Ryan Newton on 12/11/15.
//  Copyright (c) 2015 ___rvkn___. All rights reserved.
//

import UIKit
import CoreLocation
import UIKit



class ViewController: UIViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()

    @IBOutlet weak var actionLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        actionLabel.alpha = 0
        startSendingLocation()
        self.setupLocationManager()
    }

    @IBAction func displayCoordinates(sender: UIButton) {
        powerUpAndSendLocation()
        
     }
    
    func startSendingLocation() {
        NSTimer.scheduledTimerWithTimeInterval(300.0, target: self, selector: "powerUpAndSendLocation", userInfo: nil, repeats: true)
    }
    
    func powerUpAndSendLocation() {
        powerUpLocationManager()
        sendLocationData()
        powerDownLocationManager()
    }
    
    func powerUpLocationManager() {
        // Get the most accurate data
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = kCLDistanceFilterNone
    }
    
    func powerDownLocationManager() {
        // Conserve battery
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.distanceFilter = 10000000
    }
    
    func sendLocationData() {
        let locationCoordinates = LocationCoordinates()
        locationCoordinates.location = getCurrentLocationAsString()
        
        locationCoordinates.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                self.showLocationSavedLabel()
                print("saved")
            } else {
                print("error")
            }
        }
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        powerUpLocationManager()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if UIApplication.sharedApplication().applicationState == UIApplicationState.Active {
            print(getCurrentLocationAsString())
        }
            
        else if UIApplication.sharedApplication().applicationState == UIApplicationState.Background {
            NSLog("App is backgrounded. New location is %@", getCurrentLocationAsString())
        }
        
//        sendLocationData()
    }
    
    func getCurrentLocationAsString() -> String {
        if let location = locationManager.location {
            return "\(location.coordinate.latitude),\(location.coordinate.longitude)"
        } else {
            return ""
        }
    }
    
    func hasRealLocation() -> Bool {
        return !(locationManager.location == nil)
    }
    
    func showLocationSavedLabel() -> Void {
        // This is really just here to visually display that something is happening
        UIView.animateWithDuration(0.5) {
            self.actionLabel.alpha = 1
            NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "hideLocationSavedLabel", userInfo: nil, repeats: false)
        }
    }
    
    func hideLocationSavedLabel() -> Void {
        UIView.animateWithDuration(0.5) {
            self.actionLabel.alpha = 0
            
        }
        
    }
    
}

