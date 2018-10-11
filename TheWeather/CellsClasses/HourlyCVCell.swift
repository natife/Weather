
import UIKit

class HourlyCVCell: UICollectionViewCell{
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    
    func setup(withHour hour: Date, image: String, temp: String){
        let dateStr = DatesFormatter.format(from: hour, toFormat: "HH")
        hourLabel.text = dateStr
        iconImageView.image = UIImage(named: image)
        tempLabel.text = temp
    }
}
