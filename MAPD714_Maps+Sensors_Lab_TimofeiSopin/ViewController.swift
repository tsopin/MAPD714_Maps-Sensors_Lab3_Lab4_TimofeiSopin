//
//  ViewController.swift
//  MAPD714_Maps+Sensors_Lab_TimofeiSopin
//
//  Created by Timofei Sopin on 2018-04-19.
//  Copyright © 2018 Timofei Sopin. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
  
  @IBOutlet weak var setBtn: UIButton!
  @IBOutlet weak var addButtonOutlet: UIBarButtonItem!
  @IBOutlet weak var latTextfield: UITextField!
  
  @IBOutlet weak var longTextfield: UITextField!
  @IBOutlet weak var mapView: MKMapView!
  
  @IBOutlet weak var blurView: UIVisualEffectView!
  @IBOutlet var setView: UIView!
  
  var latitude = Double()
  var longitude = Double()
  
  var blurEffect: UIVisualEffect!
  var manager = CLLocationManager()
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    blurEffect = blurView.effect
    blurView.effect = nil
    blurView.isHidden = true
    let span = MKCoordinateSpanMake(0.01, 0.01)
    let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: span)
    

  }
  
  @IBAction func standard(_ sender: Any) {
    
    mapView.mapType = MKMapType.standard
    
    
  }
  
  @IBAction func satellite(_ sender: Any) {
    mapView.mapType = MKMapType.satellite
  }
  
  @IBAction func hybrid(_ sender: Any) {
    mapView.mapType = MKMapType.hybrid
  }
  
  @IBAction func myLocation(_ sender: Any) {
    
    manager.delegate = self
    
    manager.desiredAccuracy = kCLLocationAccuracyBest
    manager.requestWhenInUseAuthorization()
    manager.startUpdatingLocation()
    
    mapView.showsUserLocation = true
    
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let userLocation : CLLocation = locations[0] as CLLocation
    manager.stopUpdatingLocation()
    
    let location = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
    
    let span = MKCoordinateSpanMake(0.01, 0.01)
    
    let region = MKCoordinateRegion(center: location, span: span)
    
    mapView.setRegion(region, animated: true)
  }
  
  @IBAction func set(_ sender: Any) {
    
    guard let lat = latTextfield.text else {return}
    guard let long = longTextfield.text else {return}
    
//    latitude = Double(lat)
//    longitude = Double(long)
    
    if latTextfield.text != "" && longTextfield.text != "" {
    
    getLocatin(forLatitude: Double(lat)!, forLongitude: Double(long)!)
    
    }
     dismissView()
  }
  func getLocatin(forLatitude: Double, forLongitude: Double) {
    let span = MKCoordinateSpanMake(0.1, 0.01)
    let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: forLatitude, longitude: forLongitude), span: span)
    
    mapView.setRegion(region, animated: true)
    
    let pinLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(forLatitude, forLongitude)
    let pinObject = MKPointAnnotation()
    
    pinObject.coordinate = pinLocation
    pinObject.title = "You entered"
    pinObject.subtitle = "This Location"
    
    self.mapView.addAnnotation(pinObject)
  }
  
  @IBAction func cancel(_ sender: Any) {
    dismissView()
  }
  
  
  func showView()  {
    self.view.addSubview(setView)
    
    setView.center = self.view.center
    setView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
    setView.alpha = 0
    setView.layer.borderWidth = 1
    setView.layer.borderColor = UIColor.lightGray.cgColor
    addButtonOutlet.isEnabled = false
    
    UIView.animate(withDuration: 0.2) {
      self.blurView.effect = self.blurEffect
      self.blurView.isHidden = false
      self.setView.alpha = 1
      //      self.setBtn.isEnabled = false
      self.setView.layer.cornerRadius = 20
      
      self.setView.transform = CGAffineTransform.identity
    }
  }
  
  func dismissView() {
    UIView.animate(withDuration: 0.2, animations: {
      self.setView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
      self.setView.alpha = 0
      self.blurView.effect = nil
      self.blurView.isHidden = true
      self.addButtonOutlet.isEnabled = true
    }) { (success: Bool) in
      self.setView.removeFromSuperview()
      
    }
    
  }
  
  func generateRandomOnShake() {
    //lat 90
    // long 180
    let randomLatitude  = Double.random(min: -90.00, max: 90.00)
    let randomLongitude  = Double.random(min: -180.00, max: 180.00)
    
    getLocatin(forLatitude: randomLatitude, forLongitude: randomLongitude)
    
  }
  override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
    generateRandomOnShake()
  }
  
  
  @IBAction func enterLocation(_ sender: Any) {
    showView()
  }
  
}

public extension Double {
  
  /// Returns a random floating point number between 0.0 and 1.0, inclusive.
  public static var random: Double {
    return Double(arc4random()) / 0xFFFFFFFF
  }
  
  /// Random double between 0 and n-1.
  ///
  /// - Parameter n:  Interval max
  /// - Returns:      Returns a random double point number between 0 and n max
  public static func random(min: Double, max: Double) -> Double {
    return Double.random * (max - min) + min
  }
}

