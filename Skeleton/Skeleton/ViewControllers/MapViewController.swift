//
//  MapViewController.swift
//  SaitamaCycles
//
//  Created by Nilesh K on 31/05/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: BaseViewController, GMSMapViewDelegate {
    // MARK: - View Life Cycle
    let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
    var mapView:GMSMapView?
    
    override func loadView() {
        self.navigationBar?.backgroundColor = UIColor.green
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView?.delegate = self
        view = mapView
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
        
        performAPICall()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - GMSMapViewDelegate Methods
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        print("tapped")
        
        let paymentViewController: PaymentViewController = self.storyboard!.instantiateViewController(withIdentifier: "PaymentViewController") as! PaymentViewController
        paymentViewController.placeId = marker.userData as? String
        paymentViewController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        paymentViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(paymentViewController, animated: true, completion: nil)
    }
    
    // MARK: - API Calls Methods
    
    func performAPICall(){
        RequestManager().getPlaceList() { (success, response) in
            print(response ?? Constants.kErrorMessage)
            if success {
                self.didPlacesReceived(placeList:(response as? Array<PlaceModel>)!)
            }
            else{
                let message:String? = response as? String
                BannerManager.showFailureBanner(subtitle: message ?? Constants.kErrorMessage)
            }
        }
    }
    
    // MARK: - API Calls Methods
    
    func didPlacesReceived(placeList:Array<PlaceModel>){
        var bounds = GMSCoordinateBounds()
        for place in placeList {
            // Creates a marker in the center of the map.
            let marker = GMSMarker()
            if let lat = place.location?.latitude {
                if let long = place.location?.latitude {
                    marker.position = CLLocationCoordinate2D(latitude: Double(lat)!, longitude: Double(long)!)
                    bounds = bounds.includingCoordinate(marker.position)
                    marker.title = place.name
                    marker.userData = place.id
                    marker.map = mapView
                }
            }
            
        }
        
        mapView?.animate(with: GMSCameraUpdate.fit(bounds, with: UIEdgeInsetsMake(50.0 , 50.0 ,50.0 ,50.0)))
    }


}

