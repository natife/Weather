
import UIKit

class DailyCell: UITableViewCell, NibCell, ConfigurableCell{
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    
    func config(for weather: List) {
        self.selectionStyle = .none
        let date = weather.dt_txt
        dayLabel.text = DatesFormatter.format(from: date, toFormat: "E")
        tempLabel.text = "\(KelvinToCelsius.convert(weather.main.temp_max))º/\(KelvinToCelsius.convert(weather.main.temp_min))º"
        guard let firstWeather = weather.weather.first else { return }
        weatherImageView.image = UIImage(named: firstWeather.icon)
        weatherImageView.tintColor = .black
    }
}
