//
//  MapController.swift
//  App1
//
//  Created by Gabriel Castillo on 6/15/24.
// TODO: Add location to the database.

import UIKit
import MapKit
import CoreLocation

class MapController: UIViewController {
    // Allows user to specify task location on a map.
    
    // MARK: - Variables
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 10000
    var previousLocation: CLLocation?
    
    // MARK: - UI Components
    private let pinImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .red
        iv.image = UIImage(systemName: "mappin")
        return iv
    }()
    
    private let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.backgroundColor = .blue
        return mapView
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.backgroundColor = .white
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.text = ""
        label.numberOfLines = 2
        return label
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.checkLocationServices()
        setupUI()
        setupNavBar()
    }
    
    // MARK: - UI Setup
    private func setupNavBar() {
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.titleTextAttributes =
        [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .semibold)]
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(tappedDoneButton))
        self.navigationItem.title = "Select Location"
    }
    
    private func setupUI() {
        self.view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        //
        self.view.addSubview(addressLabel)
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(pinImage)
        pinImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pinImage.heightAnchor.constraint(equalToConstant: 40),
            pinImage.widthAnchor.constraint(equalToConstant: 40),
            pinImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            pinImage.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -40),
            
            addressLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -90),
            addressLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            addressLabel.heightAnchor.constraint(equalToConstant: 60),
            addressLabel.widthAnchor.constraint(equalToConstant: 300),
            
            mapView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 115),
            mapView.bottomAnchor.constraint(equalTo: self.addressLabel.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
    }
    
    
    // MARK: - Functions & Selectors
    func setupLocationManager() {
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func checkLocationServices() {
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.setupLocationManager()
                self.checkLocationAuthorization()
            } else {
                // TODO: Show alert letting the user know they have to turn this on.
            }
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager().authorizationStatus {
        case .authorizedWhenInUse:
            startTackingUserLocation()
        case .denied:
            // Show alert instructing them how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // Show an alert letting them know what's up
            break
        case .authorizedAlways:
            break
        @unknown default:
            break
        }
    }
    
    func startTackingUserLocation() {
        mapView.showsUserLocation = true
        centerViewOnUserLocation()
        locationManager.startUpdatingLocation()
        previousLocation = getCenterLocation(for: mapView)
    }
    
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    @objc func tappedDoneButton() {
        if let createJobController = self.navigationController?.viewControllers.first(where: { $0 is CreateJobController }) as? CreateJobController {
            createJobController.jobDateTimeView.addressLabel.text = self.addressLabel.text
        }
        self.navigationController?.popViewController(animated: true)
    }
}

extension MapController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}

extension MapController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getCenterLocation(for: mapView)
        let geoCoder = CLGeocoder()
        
        guard let previousLocation = self.previousLocation else { return }
        
        guard center.distance(from: previousLocation) > 50 else { return } // Distance req to update.
        self.previousLocation = center
        
        geoCoder.reverseGeocodeLocation(center) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Error getting reverse geocode in MapController: \(error)")
                return
            }
            
            guard let placemark = placemarks?.first else {
                return
            }
            
            let streetNumber = placemark.subThoroughfare ?? ""
            let streetName = placemark.thoroughfare ?? ""
            let city = placemark.locality ?? ""
            let state = placemark.administrativeArea ?? ""
            let postalCode = placemark.postalCode ?? ""
            let country = placemark.country ?? ""

            DispatchQueue.main.async {
                self.addressLabel.text = "\(streetNumber) \(streetName), \(city), \(state) \(postalCode), \(country)"
            }
        }
    }
}
    
    
