//
//  ViewController.swift
//  card-game
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var name_lbl: UILabel!
    @IBOutlet weak var continue_btn: UIButton!
    @IBOutlet weak var name_insert_btn: UIButton!
    @IBOutlet weak var west_img: UIImageView!
    @IBOutlet weak var east_img: UIImageView!
    
    var name: String = ""
    
    let locationManager = CLLocationManager()
    let middleLongitude: Double = 34.817549168324334
    
    // nil = unchosen, true = left, false = right
    var isPlayerOnLeft: Bool?
    
    @IBAction func name_insert_btn(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Welcome", message: "Enter your name", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Name"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "Save", style: .default) { _ in

            guard let inputName = alertController.textFields?.first?.text,
            !inputName.isEmpty else { return }
            
            self.name = inputName.capitalized
            self.name_lbl.text = "Hello \(self.name)"
            self.checkEnableContinue()

        }

        alertController.addAction(cancelAction)
        alertController.addAction(okAction)

        present(alertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? GameViewController {
            destination.name = self.name
            if let isOnLeft = isPlayerOnLeft {
                destination.isPlayerOnLeft = isOnLeft
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Force button label to be one line by decreasing font size as in some iPhones it's too long
        let buttonSet: Set<UIButton> = [name_insert_btn, continue_btn]
        for button in buttonSet {
            button.titleLabel?.numberOfLines = 1
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.titleLabel?.minimumScaleFactor = 0.5
        }
        
        if !name.isEmpty {
            name_lbl.text = "Hello \(name)"
            continue_btn.isEnabled = true
        }
        
        // Fade images and unfade the selected one based on user location
        west_img.alpha = 0.3
        east_img.alpha = 0.3
        
        setupLocation()
        checkEnableContinue()
    }
    
    func setupLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers // Estimated location not exact
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        locationManager.stopUpdatingLocation()
        let longitude = location.coordinate.longitude
        
        isPlayerOnLeft = longitude < middleLongitude
        
        if isPlayerOnLeft == true {
            west_img.alpha = 1.0
            east_img.alpha = 0.3
        } else {
            west_img.alpha = 0.3
            east_img.alpha = 1.0
        }
        
        checkEnableContinue()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        } else if status == .denied || status == .restricted {
            showSettingsAlert()
        }
    }
    
    func showSettingsAlert() {
        let alert = UIAlertController(
                    title: "Location Required",
                    message: "The app needs your location to figure out which side of the table you sit on! Please enable it in your settings to continue.",
                    preferredStyle: .alert
                )
                
        let settingsAction = UIAlertAction(title: "Go to Settings", style: .default) { _ in
            // Opens iPhone's settings
            if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsUrl)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        alert.addAction(settingsAction)
        
        present(alert, animated: true)
    }
    
    func checkEnableContinue() {
        if !name.isEmpty && isPlayerOnLeft != nil {
            continue_btn.isEnabled = true
        } else {
            continue_btn.isEnabled = false
        }
    }

    // Returns the last screen to the home menu by clearing prev screens from the stack until we reach the first screen with unwindToStart
    // Used in order to avoid infinite stacks and being able to retain the name set previously
    @IBAction func unwindToStart(_ segue: UIStoryboardSegue) {
    }

}

