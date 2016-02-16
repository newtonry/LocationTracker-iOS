//
//  LocationCoordinates.swift
//  LocationTracker
//
//  Created by Ryan Newton on 12/12/15.
//  Copyright © 2015 ___rvkn___. All rights reserved.
//

import Foundation


class LocationCoordinates : PFObject, PFSubclassing {
    @NSManaged var location: String?
    @NSManaged var username: String?
    @NSManaged var timeVisited: NSDate?
    @NSManaged var horizontalAccuracy: NSNumber?
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func fromCLLocation(location: CLLocation) -> LocationCoordinates {
        let locationCoordinates = LocationCoordinates();
        locationCoordinates.username = "Ryan-iOS"  // Just defaulting to this for now
        locationCoordinates.location = "\(location.coordinate.latitude),\(location.coordinate.longitude)"
        locationCoordinates.timeVisited = NSDate()
        locationCoordinates.horizontalAccuracy = location.horizontalAccuracy
        return locationCoordinates
    }

    static func parseClassName() -> String {
        return "LocationCoordinates"
    }
}