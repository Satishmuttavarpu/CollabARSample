//
//  CollabMapViewController.swift
//  CollabARSample
//
//  Created by Satish Muttavarapu on 27/08/19.
//  Copyright © 2019 Wipro. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class CollabMapViewController: UIViewController{
    
    //An MKMapView object provides an embeddable map interface
    @IBOutlet weak var mapView: MKMapView!
    //create a locationManager property
    let locationManager = CLLocationManager()
    //create another locationManager property
    let locationManagerNew = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set up locationManager so it can find current location as soon as it's loaded.
        // delegate is the delegate object to receive update events. Self returns the receiver
        self.locationManager.delegate = self
        // Use the second highest level of accuracy
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // Requests permission to use location services while the app is in the foreground, we don't want to use location services when the app is in the background
        self.locationManager.requestWhenInUseAuthorization()
        // Starts the generation of updates that report the user's current location
        self.locationManager.startUpdatingLocation()
        // A boolean value indicating whether the map should try to display the user's location
        self.mapView.showsUserLocation = true
        
    }
    
    // MARK: - Users Interactions
    @IBAction func skipMethod(_ sender: Any) {
        
        //Present AR camera ViewController
        presentViewController()
    }
    
    @IBAction func startMeasureMethod(_ sender: Any) {
        
        //Present AR camera ViewController
        presentViewController()
    }
    
    // MARK: - Privates
    private func presentViewController(){
       
        if let arVC = self.storyboard?.instantiateViewController(withIdentifier: "CollabRoomViewController") as? CollabRoomViewController {
            self.present(arVC, animated: true, completion: nil)
        }
   /*
        if let arVC = self.storyboard?.instantiateViewController(withIdentifier: "ARViewController") as? ViewController {
            self.present(arVC, animated: true, completion: nil)
        }
 */
        
    }
}

// MARK - Location Delegate Methods
extension CollabMapViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Get last location of locations that have been passed in (most current)
        let location = locations.last
        // For future use
        print(location!.coordinate.latitude)
        print(location!.coordinate.longitude)
        // Get center of that location, i.e. latitude and longitude from that location variable
        let center =  CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        //  Area for map to zoom to. A smaller number zooms further in. Zooming into user's current location. MKCoordinateRegion is a structure which defines which portion of the map to display; center is the centerpoint of the region displayed. The span defines the horizontal and vertical span representing the amount of map to display. The span also defines the current zoom level used by the map view object. 1 and 1 is the zoom.
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta:1, longitudeDelta: 1))
        // change currently visible region to that region and animate this change
        self.mapView.setRegion(region, animated: true)
        //Stop the generation of location updates.
        self.locationManager.stopUpdatingLocation()
    }
    
    //manager is the location manager object that was unable to retrieve the location; error is the error object containing the reason the location or heading could not be retrieved.
    private func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print ("Errors: "  + error.localizedDescription)
    }
    
}
