//
//  BeaconManager.swift
//  Open Sesame
//
//  Created by Ryan Passage on 10/20/15.
//  Copyright © 2015 Ryan Passage. All rights reserved.
//

import UIKit
import CoreLocation

extension CLProximity {
    var stringValue: String {
        let values = ["Unknown", "Immediate", "Near", "Far"]
        return values[self.hashValue]
    }
}

class BeaconManager: NSObject {
    // properties
    dynamic var canUseLocation = false
    dynamic var isMonitoring = false
    dynamic var isRanging = false
    dynamic var beacons = [CLBeacon]()

    let locationManager = CLLocationManager()
    let region = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!, identifier: "CMWA")
    
    // Singleton - we should only be managing beacons with one object, not multiple managers
    static let sharedInstance = BeaconManager()
    
    private override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    }
    
    func startLookingForBeacons() {
        guard self.canUseLocation == true else { return }
        
        // TODO: change to always be monitoring and only range when in a region
        locationManager.startMonitoringForRegion(region)
        locationManager.startRangingBeaconsInRegion(region)
        
        isMonitoring = true
        isRanging = true
    }
    
    func stopLookingForBeacons() {
        
        // TODO: change to only stop ranging when outside of a region; always be monitoring
        locationManager.stopMonitoringForRegion(region)
        locationManager.stopRangingBeaconsInRegion(region)
        
        isMonitoring = false
        isRanging = false
    }

}

extension BeaconManager: CLLocationManagerDelegate {
    
    // MARK: - Region Monitoring
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        // TODO: Change "looking for beacons" procedure to only range when we've entered a region
        
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        // TODO: Turn off ranging when we exit a region (but leave monitoring turned on)
        
    }
    
    // MARK: - Ranging
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        self.beacons = beacons
    }
    
    // MARK: - Location Permission Changes
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .AuthorizedAlways, .AuthorizedWhenInUse:
            canUseLocation = true
            startLookingForBeacons()
        default:
            canUseLocation = false
            stopLookingForBeacons()
        }
    }
    
}