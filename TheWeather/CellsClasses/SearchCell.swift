
import UIKit

class SearchCell: UITableViewCell, NibCell, ConfigurableCell{
    @IBOutlet weak var cityLabel: UILabel!
    
    func config(for weather: Prediction) {
        cityLabel.text = "\(weather.structured_formatting.main_text), \(weather.structured_formatting.secondary_text)" 
    }
}
