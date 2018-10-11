
import UIKit

class HeaderCell: UITableViewCell, NibCell, ConfigurableCell{
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var openMapButton: UIButton!
    @IBOutlet weak var windDirectionImageView: UIImageView!
    
    func config(for weather: WeatherCurrentModel) {
        self.selectionStyle = .none
        let date = Date(timeIntervalSince1970: Double(weather.dt))
        dayLabel.text = DatesFormatter.format(from: date, toFormat: "E, d MMM")
        cityLabel.text = weather.name
        temperatureLabel.text = "\(KelvinToCelsius.convert(weather.main.temp))º"
        humidityLabel.text = "\(weather.main.humidity)%"
        windLabel.text = "\(weather.wind.speed)m/s"
        weatherImageView.image = UIImage(named: weather.weather.first!.icon)
        UIView.animate(withDuration: 1) {
            self.windDirectionImageView.transform = self.windDirectionImageView.transform.rotated(by: CGFloat(weather.wind.deg))
        }
    }
}
