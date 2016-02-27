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
    var unsavedLocations = [LocationCoordinates]()

    @IBOutlet weak var actionLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        startSendingLocation()
        self.setupLocationManager()
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        powerUpLocationManager()
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringVisits()
    }

    @IBAction func displayCoordinates(sender: UIButton) {
        powerUpAndSendLocation()
        showLocationSavedLabel()
     }
    
    func startSendingLocation() {
        // Start the loop to send locations at intervals
        NSTimer.scheduledTimerWithTimeInterval(300.0, target: self, selector: "powerUpAndSendLocation", userInfo: nil, repeats: true)
    }
    
    func powerUpAndSendLocation() {
        // Performs all the actions
        powerUpLocationManager()
        recordLocation()
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
    
    func recordLocation() {
        // Adds the location to the list of unsaved locations
        if let location = locationManager.location {
            let locationCoordinates = LocationCoordinates.fromCLLocation(location)
            unsavedLocations.append(locationCoordinates)
        } else {
            print("There currently is no location")
        }
    }
    
    func sendLocationData() {
        // Saves all the unsaved locations if there's an internet connection
        for locationCoordinates in unsavedLocations {
            locationCoordinates.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    self.showLocationSavedLabel()
                    self.removeAllSavedLocationCoordinated()
                    print("The location was successfully saved to the server.")
                } else {
                    print("There was an error saving the location.")
                }
            }
        }
    }
    
    func removeAllSavedLocationCoordinated() {
        // All the locations that have objectIds have been saved, so filter those out.
        unsavedLocations = unsavedLocations.filter({
            $0.objectId == nil
        })
        print("There are now \(unsavedLocations.count) unsaved locations")
    }
    
    func locationManager(manager: CLLocationManager, didVisit clVisit: CLVisit) {
        let visit = Visit.fromCLVisit(clVisit)
        visit.saveInBackground()
        print("didVisit event received")
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if UIApplication.sharedApplication().applicationState == UIApplicationState.Active {
            print(getCurrentLocationAsString())
        }
            
        else if UIApplication.sharedApplication().applicationState == UIApplicationState.Background {
            NSLog("App is backgrounded. New location is %@", getCurrentLocationAsString())
        }
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

