//
//  LocationController.swift
//  SpoonFW
//
//  Created by Jan Löffel on 30.09.22.
//

import Foundation
import CoreLocation
import MapKit
import Contacts

public struct LocationAnnotation: Identifiable {
    public let coordinate: CLLocationCoordinate2D
    public let title: String?
    public let id: UUID = UUID()
    
    public init(coordinate: CLLocationCoordinate2D, title: String? = nil) {
        self.coordinate = coordinate
        self.title = title
    }
}

public class GeoController: NSObject, ObservableObject, CLLocationManagerDelegate {

    public let locationManager = CLLocationManager()
    public let geocoder = CLGeocoder()

    @Published public var locationStatus: CLAuthorizationStatus?
    @Published public var location: CLLocation?

    public override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
//        locationManager.startUpdatingLocation()
    }

    public var statusString: String {
        guard let status = locationStatus else {
            return "unknown"
        }
        
        switch status {
        case .notDetermined: return "notDetermined"
        case .authorizedWhenInUse: return "authorizedWhenInUse"
        case .authorizedAlways: return "authorizedAlways"
        case .restricted: return "restricted"
        case .denied: return "denied"
        default: return "unknown"
        }
    }

    public static func convertTap(at point: CGPoint, for mapSize: CGSize, in region: MKCoordinateRegion) -> CLLocationCoordinate2D {
        let lat = region.center.latitude
        let lon = region.center.longitude
        
        let mapCenter = CGPoint(x: mapSize.width / 2.0, y: mapSize.height / 2.0)
        
        // X
        let xValue = (point.x - mapCenter.x) / mapCenter.x
        let xSpan = xValue * region.span.longitudeDelta / 2.0
        
        // Y
        let yValue = (point.y - mapCenter.y) / mapCenter.y
        let ySpan = yValue * region.span.latitudeDelta / 2.0
        
        return CLLocationCoordinate2D(latitude: lat - ySpan, longitude: lon + xSpan)
    }

    public static func postalAddress(country: String = "", postalCode: String = "", city: String = "", street: String = "", houseNumber: String = "") -> CNPostalAddress {
        let result = CNMutablePostalAddress()
        result.country = country
        result.postalCode = postalCode
        result.city = city
        result.street = String(format: "%@ %@", street, houseNumber)
        
        return result
    }

    public static func postalAddressString(country: String = "", postalCode: String = "", city: String = "", street: String = "", houseNumber: String = "") -> String {
        let result = postalAddress(country: country, postalCode: postalCode, city: city, street: street, houseNumber: houseNumber)
        
        let postalAddressFormatter = CNPostalAddressFormatter()
        postalAddressFormatter.style = .mailingAddress

        return postalAddressFormatter.string(from: result)
    }
    
    public static func postalAddressString(placemark: CLPlacemark?) -> String {
        var result: String = ""
        
        let postalAddressFormatter = CNPostalAddressFormatter()
        postalAddressFormatter.style = .mailingAddress
        
        if let pm = placemark, let postalAddress = pm.postalAddress {
            result = postalAddressFormatter.string(from: postalAddress)
        }
        
        return result
    }
    
    public func placemark(postalAddress: CNPostalAddress) -> CLPlacemark? {
        var result: CLPlacemark? = nil
        
        geocoder.geocodePostalAddress(postalAddress) { placemarks, error in
                result = placemarks?.first
        }
        
        return result
    }
    
    public func lookUpLocation(location: CLLocationCoordinate2D?, completionHandler: @escaping (CLPlacemark?)
                    -> Void ) {
        // Use the last reported location.
        if let lastLocation = location {
            // Look up the location and pass it to the completion handler
            geocoder.reverseGeocodeLocation(CLLocation(latitude: lastLocation.latitude, longitude: lastLocation.longitude),
                        completionHandler: { (placemarks, error) in
                if error == nil {
                    let firstLocation = placemarks?.first
                    completionHandler(firstLocation)
                }
                else {
                 // An error occurred during geocoding.
                    completionHandler(nil)
                }
            })
        }
        else {
            // No location was available.
            completionHandler(nil)
        }
    }

    public func lookUpCurrentLocation(completionHandler: @escaping (CLPlacemark?)
                    -> Void ) {
        // Use the last reported location.
        if let lastLocation = self.locationManager.location {
            // Look up the location and pass it to the completion handler
            geocoder.reverseGeocodeLocation(lastLocation,
                        completionHandler: { (placemarks, error) in
                if error == nil {
                    let firstLocation = placemarks?.first
                    completionHandler(firstLocation)
                }
                else {
                 // An error occurred during geocoding.
                    completionHandler(nil)
                }
            })
        }
        else {
            // No location was available.
            completionHandler(nil)
        }
    }

    public func requestLocation() {
        locationManager.requestLocation()
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationStatus = status
        print(#function, statusString)
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last
        print(#function, location.debugDescription)
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function, error.localizedDescription)
    }
}
