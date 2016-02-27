//
//  Visit.swift
//  LocationTracker
//
//  Created by Ryan Newton on 2/27/16.
//  Copyright © 2016 ___rvkn___. All rights reserved.
//

import Foundation


class Visit : PFObject, PFSubclassing {
    @NSManaged var location: String?
    @NSManaged var username: String?
    @NSManaged var arrivalDate: NSDate?
    @NSManaged var departureDate: NSDate?
    @NSManaged var horizontalAccuracy: NSNumber?
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func fromCLVisit(clVisit: CLVisit  ) -> Visit {
        let visit = Visit();
        visit.username = "Ryan-iOS"  // Just defaulting to this for now
        visit.location = "\(clVisit.coordinate.latitude),\(clVisit.coordinate.longitude)"
        visit.arrivalDate = clVisit.arrivalDate
        visit.departureDate = clVisit.departureDate
        visit.horizontalAccuracy = clVisit.horizontalAccuracy
        return visit
    }
    
    static func parseClassName() -> String {
        return "Visit"
    }
}