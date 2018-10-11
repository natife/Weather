
import UIKit
import MapKit

enum Sections: Int{
    case header, hourly, daily, count
}

class ViewController: UITableViewController {
    
    let locationManager = CLLocationManager()
    var currentLocation = CLLocation(){
        didSet{
            performRequest(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude, cityName: cityName)
        }
    }
    
    var requestType: WeatherRequest = .coords
    var cityName: String!{
        didSet{
            performRequest(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude, cityName: cityName)
        }
    }
    
    let apiService = APIService()
    var weatherModel: WeatherModel!
    
    var days = [List]()
    var hourly = [List]()
    
    
    var weatherCurrent: WeatherCurrentModel!
    
    private func reloadTableView(){
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        if cityName == nil{
            locationManager.startUpdatingLocation()
        }
        
        tableView.register(cell: HeaderCell.self)
        tableView.register(cell: HourlyCell.self)
        tableView.register(cell: DailyCell.self)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Sections.count.rawValue
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = Sections.init(rawValue: section)!
        switch section{
        case .header:
            return 1
        case .hourly:
            return 1
        case .daily:
            return days.count
        case .count:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = Sections.init(rawValue: indexPath.section)!
        guard let current = weatherCurrent else { return UITableViewCell() }
        switch section {
        case .header:
            let cell = tableView.dequeueReusableCell(ofType: HeaderCell.self, for: indexPath)
            cell.config(for: current)
            cell.openMapButton.addTarget(self, action: #selector(openMapAction(_:)), for: .touchUpInside)
            return cell
        case .hourly:
            let cell = tableView.dequeueReusableCell(ofType: HourlyCell.self, for: indexPath)
            cell.config(for: hourly)
            return cell
        case .daily:
            let cell = tableView.dequeueReusableCell(ofType: DailyCell.self, for: indexPath)
            let day = days[indexPath.row]
            cell.config(for: day)
            return cell
        case .count:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
    }
}

extension ViewController{
    @objc func openMapAction(_ sender: UIButton){
        let mapVC = SelectLocationViewController.instantiate()
        mapVC.delegate = self
        self.navigationController?.pushViewController(mapVC, animated: true)
    }
    
    func performRequest(_ lat: Double?, _ long: Double?, cityName: String?){
        apiService.getWeather(by: requestType, fromLat: lat, andLong: long, cityName: cityName) { (weather) in
            guard weather != nil else { return }
            self.weatherCurrent = weather!
        }
        
        apiService.getForecast(by: requestType, fromLat: lat, andLong: long, cityName: cityName) { (weather) in
            guard weather != nil else { return }
            self.weatherModel = weather!
            
            self.days = [List]()
            let sortedDays = self.weatherModel.list.sorted(by: { $0.dt < $1.dt })
            sortedDays.forEach({ self.addDay($0) })
            
            let cal = Calendar(identifier: .gregorian)
            self.hourly = self.weatherModel.list.compactMap({ cal.isDate($0.dt_txt, inSameDayAs: Date()) ? $0 : nil })
            self.reloadTableView()
        }
    }
    
    func addDay(_ day:List){
        
        struct MyCalendar {
            static let calendar = Calendar(identifier: .gregorian)
        }
        
        guard var lastDay = days.last else {
            days.append(day)
            return
        }
        
        let isSameDay = MyCalendar.calendar.isDate(lastDay.dt_txt, inSameDayAs: day.dt_txt)
        
        if isSameDay{
            
            if lastDay.main.temp_min > day.main.temp_min {
                lastDay.main.temp_min = day.main.temp_min
            }
            
            if lastDay.main.temp_max < day.main.temp_max{
                lastDay.main.temp_max = day.main.temp_max
            }
            
            let index = days.count - 1
            days[index] = lastDay
        }else{
            days.append(day)
        }
    }
}

//MARK: - CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways{
            guard let location = manager.location else { return }
            currentLocation = location
        }
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location else { return }
        currentLocation = location
        manager.stopUpdatingLocation()
    }
}

extension ViewController: SelectLocationViewControllerDelegate{
    func returnLocation(from: SelectLocationViewController, location: CLLocation) {
        performRequest(location.coordinate.latitude, location.coordinate.longitude, cityName: cityName)
    }
}
