//
//  PhotoMapViewController.swift
//  Photo Map
//
//  Created by Nicholas Aiwazian on 10/15/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit


class PhotoMapViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, LocationsViewControllerDelegate, MKMapViewDelegate  {
    
    var image = UIImage(named: "camera")
    
    var originaPickImage: UIImage?
    var editedPickImage: UIImage?
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func cameraButton(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("Camera is available 📸")
            vc.sourceType = .camera
        } else {
            print("Camera 🚫 available so we will use photo library instead")
            vc.sourceType = .photoLibrary
        }
        
        self.present(vc, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //one degree of latitude is approximately 111 kilometers (69 miles) at all times.
        let sfRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.783333, -122.416667), MKCoordinateSpanMake(0.1, 0.1))
        mapView.setRegion(sfRegion, animated: false)
        mapView.delegate = self
        
    }
    
    
    func locationsPickedLocation(controller: LocationsViewController, latitude: NSNumber, longitude: NSNumber) {
        let locationCoordinate = CLLocationCoordinate2D(latitude: latitude.doubleValue,longitude: longitude.doubleValue)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = locationCoordinate
        annotation.title = "Latitude: \(Double(round(100*Double(latitude))/100)) Longitude: \(Double(round(100*Double(longitude))/100))"
        //annotation.photo = image
        mapView.addAnnotation(annotation)
    }
    
    //  delegate.locationsPickedLocation(controller: self, latitude: lat, longitude: lng)

    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        // Do something with the images (based on your use case)
        self.image = editedImage
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true, completion: nil)
        performSegue(withIdentifier: "tagSegue", sender: self)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseID = "myAnnotationView"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
        if (annotationView == nil) {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            annotationView!.canShowCallout = true
            annotationView!.leftCalloutAccessoryView = UIImageView(frame: CGRect(x:0, y:0, width: 50, height:50))
        }
        
        let imageView = annotationView?.leftCalloutAccessoryView as! UIImageView
        imageView.image = image
        return annotationView
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination as!
        // Pass the selected object to the new view controller.
        let destinationViewController = segue.destination as! LocationsViewController
        destinationViewController.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
