//
//  MapInfoViewController.swift
//  LunTest
//
//  Created by Maksym Bondar on 2/26/19.
//

import UIKit
import MapKit

class MapInfoViewController: UIViewController, MKMapViewDelegate {
    /// Segue identifier of controller.
    static let segueIdentifier = "userLocationSegueIdentifier"
    
    /// Initial location of person.
    var initialLocation: CLLocation?
    
    /// Name of person. Used for title and
    var personName: String?
    
    /// Region radius. Used for centering of map.
    private let regionRadius: CLLocationDistance = 1000
    
    /// Used for getting of user position.
    private let locationManager = CLLocationManager()
    
    /// Map view.
    @IBOutlet var mapView: MKMapView!
    
    /// Button for getting of direction from user position to coordinates on map.
    @IBOutlet var directionButton: UIButton!
    
    // MARK: ViewController lifecycle.
    /// Setup person placemark on map.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let location = initialLocation {
            let personPlacemark = PersonPlacemark(title: personName ?? "User", coordinate: location.coordinate)
            mapView.addAnnotation(personPlacemark)
        }
        self.mapView.delegate = self
    }
    
    /// Center map on location.
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let location = initialLocation {
            self.centerMapOnLocation(location: location)
        }
        checkLocationAuthorizationStatus()
    }
    
    // MARK: Extra methods.
    /// Set region of map according to user coordinates.
    private func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    /// Chech autorization status to show user position.
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
            DispatchQueue.main.async {
                self.directionButton.isHidden = self.mapView.userLocation.location != nil
            }
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    /// Request for direction from user position to person.
    @IBAction func navigateToPerson(_ sender: UIButton) {
        let request = MKDirections.Request()
        guard let destination = initialLocation else { return }
        request.source = MKMapItem(placemark: MKPlacemark(coordinate:mapView.userLocation.coordinate, addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination.coordinate, addressDictionary: nil))
        request.requestsAlternateRoutes = true
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        
        directions.calculate { [unowned self] response, error in
            guard let unwrappedResponse = response else { return }
            
            for route in unwrappedResponse.routes {
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
    }
    
    // MARK: MKMapViewDelegate
    /// Customize overlays for main and alternative paths.
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.lineWidth = 3
        if (overlay is MKPolyline) {
            if mapView.overlays.count == 1 {
                renderer.strokeColor = UIColor.orange
            } else {
                renderer.strokeColor = UIColor.orange.withAlphaComponent(0.4)
            }
        }
        return renderer
    }
}

@IBDesignable extension UIButton {
    /// Set corner radius for layer of ImageView.
    @IBInspectable private var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            clipsToBounds = true
        }
    }
}
