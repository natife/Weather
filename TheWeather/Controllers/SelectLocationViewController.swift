
import UIKit
import MapKit

protocol SelectLocationViewControllerDelegate: class{
    func returnLocation(from: SelectLocationViewController, location: CLLocation)
}

class SelectLocationViewController: UIViewController{
    @IBOutlet weak var mapView: MKMapView!
    weak var delegate: SelectLocationViewControllerDelegate?
    let initialLocation = CLLocationManager().location
    var coords = CLLocation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centerMapOnLocation(location: initialLocation!)
        let tapGR = UITapGestureRecognizer.init(target: self, action: #selector(makePoint(_:)))
        mapView.addGestureRecognizer(tapGR)
        let searchButton = UIBarButtonItem(image: UIImage(named: "ic_search"), style: .plain, target: self, action: #selector(openSearch(_:)))
        self.navigationItem.setRightBarButton(searchButton, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.returnLocation(from: self, location: coords)
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        let coordType = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        setAnnotation(for: coordType)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    @objc func openSearch(_ sender: UIBarButtonItem){
        let searchVC = SearchVewController.instantiate()
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    @objc func makePoint(_ sender: UIGestureRecognizer){
        mapView.removeAnnotations(mapView.annotations)
        let touchPoint = sender.location(in: mapView)
        let pin = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        setAnnotation(for: pin)
    }
    
    func setAnnotation(for coordinates: CLLocationCoordinate2D){
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        mapView.addAnnotation(annotation)
        
        let newCoords = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
        self.coords = newCoords
    }
}
