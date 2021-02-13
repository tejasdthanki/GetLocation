//
//  LocationController.swift
//  GetLocation
//
//  Created by Tejas Thanki on 11/02/21.
//

import UIKit
import CoreLocation
public typealias locationHandler  = (_:String?,_:CLLocation?) -> Void

public class LocationController: NSObject,CLLocationManagerDelegate {
    static let shared:LocationController = LocationController()
    public var locationHandlercallBack:locationHandler?
    var clLocationManager = CLLocationManager()
    var locationServiceMsg:String = "Location service is disable in your device.Please enable it in settings."
    var locationPermissionMsg:String = "Location permission is disable in your device.Please allow it from setting manually."
    
    public func getUserCurrentLocation(callBack:@escaping locationHandler){
        locationHandlercallBack = callBack
        if CLLocationManager.locationServicesEnabled() == true {
            if CLLocationManager.authorizationStatus() == .restricted || CLLocationManager.authorizationStatus() == .denied || CLLocationManager.authorizationStatus() == .notDetermined {
                clLocationManager.requestWhenInUseAuthorization()
            }
            clLocationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            clLocationManager.delegate = self
            clLocationManager.distanceFilter = kCLLocationAccuracyBest
        }else{
            locationHandlercallBack!(locationServiceMsg,nil)
        }
    }

    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            // If status has not yet been determied, ask for authorization
            manager.requestWhenInUseAuthorization()
            break
        case .authorizedWhenInUse,.authorizedAlways:
            self.clLocationManager.startUpdatingLocation()
            break
        case .restricted,.denied:
            // If user denied your app access to Location Services, but can grant access from Settings.app
            locationHandlercallBack!(locationPermissionMsg,nil)
            break
        default:
            break
        }
    }
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if #available(iOS 14.0, *) {
            let status = manager.authorizationStatus
            switch status {
            case .notDetermined:
                // If status has not yet been determied, ask for authorization
                manager.requestWhenInUseAuthorization()
            break
            case .authorizedWhenInUse,.authorizedAlways:
                let accuracyStatus = manager.accuracyAuthorization
                if accuracyStatus == CLAccuracyAuthorization.reducedAccuracy{
                    self.clLocationManager.requestTemporaryFullAccuracyAuthorization(withPurposeKey: "wantAccurateLocation", completion: { [self]
                        error in
                        self.clLocationManager.startUpdatingLocation()
                    })
                }else{
                    self.clLocationManager.startUpdatingLocation()
                }
                break
            case .restricted,.denied:
                // If user denied your app access to Location Services, but can grant access from Settings.app
                locationHandlercallBack!(locationPermissionMsg,nil)
            break
            default:
                break
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if(locationHandlercallBack != nil){
            locationHandlercallBack!(nil,locations[0])
        }
        locationHandlercallBack = nil
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationHandlercallBack!(error.localizedDescription,nil)
    }
}
